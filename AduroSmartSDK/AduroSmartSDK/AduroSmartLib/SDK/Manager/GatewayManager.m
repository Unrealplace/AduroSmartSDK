//
//  GatewayManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/13.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "GatewayManager.h"
#import "AduroGateway.h"
#import "LeeUDPClientManager.h"
#import "LeeMQTTClientManager.h"

@interface GatewayManager(){
    
    LeeGatewaysInLanBlock _allGetGatewayBlock;
    LeeGatewayStatusBlock _changeGateNameBlock;
    LeeGatewayStatusBlock _updateGateWayBlock;
    LeeGatewayStatusBlock _connectGateWayBlock;
    LeeGatewayStatusBlock _resetGateWayBlock;
    LeeUDPClientManager * udpClient;
    LeeMQTTClientManager* mqttClient;
    
}

@end
@implementation GatewayManager

+ (GatewayManager *)sharedManager{
    static GatewayManager *sharedGatewayManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGatewayManagerInstance = [[self alloc] init];
    });
    return sharedGatewayManagerInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [Lee_Notification addObserver:self selector:@selector(localOrRemote) name:Lee_Local_or_Remote object:nil];
        [Lee_Notification addObserver:self selector:@selector(getGateWay:) name:Lee_GET_GATEWAY object:nil];
        udpClient  = [LeeUDPClientManager sharedManager];
        mqttClient = [LeeMQTTClientManager sharedManager];

    }
    return self;
}

-(void)searchGateways:(LeeGatewaysInLanBlock)gateways{
    _allGetGatewayBlock = gateways;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(4);
        if (GlobalConnectStatus == NetTypeRemote || GlobalConnectStatus == NetTypeUnreachble) {
            _allGetGatewayBlock(nil);
        }
    });
}
-(void)getGateWay:(NSNotification*)nofi{
    AduroGateway * obj = (AduroGateway*)nofi.object;
    
    _allGetGatewayBlock(@[obj]);
}

-(void)connectGateway:(AduroGateway *)gateway andReturnCode:(LeeGatewayStatusBlock)completionHandler{
    
    _connectGateWayBlock = completionHandler;
    switch (GlobalConnectStatus) {
        case NetTypeLocal:
        {
            if (gateway.gatewayIPv4Address) {
                [udpClient setHost:gateway.gatewayIPv4Address];
                [udpClient setUdpPort:Lee_BROADCAST_PORT];
            }else{
                _connectGateWayBlock(AduroSmartReturnCodeError);

            }
            if (gateway.gatewayID.length >1) {
                [mqttClient setHost:Lee_MQTT_HOST];
                [mqttClient setTopic:gateway.gatewayID];
                [mqttClient startMQTTClientAndSuccess:^(AduroSmartLinkCode code) {
                    
                } andReceiveDataBlock:^(id data) {
                    
                } andErrorBlock:^(NSError *error) {
                    
                }];
                
            }else{
                _connectGateWayBlock(AduroSmartReturnCodeError);
                return;
            }
            AduroGateway * old = [self getCurrentGateway];
            if (![old.gatewayIPv4Address isEqualToString:gateway.gatewayIPv4Address] || ![old.gatewayID isEqualToString:gateway.gatewayID]) {
                [self saveCurrentGateway:gateway];
            }
            _connectGateWayBlock(AduroSmartReturnCodeSuccess);

        }
       break;
            case NetTypeRemote:
        {
            if (gateway.gatewayID.length >1) {
                [mqttClient setHost:Lee_MQTT_HOST];
                [mqttClient setTopic:gateway.gatewayID];
                [mqttClient startMQTTClientAndSuccess:nil andReceiveDataBlock:nil andErrorBlock:nil];
                AduroGateway * old = [self getCurrentGateway];
                if (![old.gatewayIPv4Address isEqualToString:gateway.gatewayIPv4Address] || ![old.gatewayID isEqualToString:gateway.gatewayID]) {
                    [self saveCurrentGateway:gateway];
                }
                _connectGateWayBlock(AduroSmartReturnCodeSuccess);

            }else{
                _connectGateWayBlock(AduroSmartReturnCodeError);
            }
        
        }
            break;
        case NetTypeUnreachble:
        {
            _connectGateWayBlock(AduroSmartReturnCodeError);

        }
            break;
        default:
            break;
    }
    
    [self updateGatewayDatatime:[NSDate date]];
    
}
-(AduroGateway*)getCurrentGateway{

    NSData *myEncodedObject = [Lee_Userdefault objectForKey:Lee_SAVE_GATEWAY];
    AduroGateway *obj = (AduroGateway *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}
-(void)saveCurrentGateway:(AduroGateway *)gateway{

    NSData * codeData = [NSKeyedArchiver archivedDataWithRootObject:gateway];
    [Lee_Userdefault setObject:codeData forKey:Lee_SAVE_GATEWAY];
    [Lee_Userdefault synchronize];
    
}

-(void)upgradeGatewayCompletionHandler:(LeeGatewayStatusBlock)completionHandler{
    _updateGateWayBlock = completionHandler;
    
}

-(void)changeGatewayName:(NSString *)gatewayName andCompletionHandler:(LeeGatewayStatusBlock)completionHandler{
    _changeGateNameBlock = completionHandler;
    
    
}
-(void)resetGatewayWithPwd:(NSString *)password andCompletionHandler:(LeeGatewayStatusBlock)completionHandler{
    _resetGateWayBlock = completionHandler;

    
}

-(void)updateGatewayDatatime:(NSDate *)date{
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone systemTimeZone]];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:date];
    NSInteger year = [dd year];
    Byte month = [dd month];
    Byte day  = [dd day];
    Byte hour = [dd hour];
    Byte minute = [dd minute];
    Byte second = [dd second];
    
    Byte dataLength = 7;
    Byte commandDataByte[dataLength];
    memset(commandDataByte, 0x00, dataLength);
    commandDataByte[0] = year>>8;
    commandDataByte[1] = year&0xff;
    commandDataByte[2] = month;
    commandDataByte[3] = day;
    commandDataByte[4] = hour;
    commandDataByte[5] = minute;
    commandDataByte[6] = second;
    
    NSData *saveDatatime = [[NSData alloc]initWithBytes:commandDataByte length:dataLength];
    
//    NSData *saveDatatimeData = [AduroCommandTool createCommand:CommandTypeSetDateTime serialLinkMessageType:0xffff data:saveDatatime deviceMac:nil];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self sendCommand:saveDatatimeData];
//    });

}


-(void)localOrRemote{
    
    NETLog(@"%ld",(long)GlobalConnectStatus);
}


@end
