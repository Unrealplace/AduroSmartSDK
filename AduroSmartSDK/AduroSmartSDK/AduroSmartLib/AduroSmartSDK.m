//
//  AduroSmartSDK.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "AduroSmartSDK.h"
#import "AduroSmartSDK+AnalysisData.h"
#import "LeeUDPClientManager.h"
#import "LeeMQTTClientManager.h"
#import "AduroGateway.h"
#import "NetTypeModel.h"
#import "Reachability.h"

@interface AduroSmartSDK()<mqttConnectDelegate>

@property(nonatomic,strong)LeeUDPClientManager   * udpClient;
@property(nonatomic,strong)LeeMQTTClientManager  * mqttClient;
@property(nonatomic,strong)Reachability          * netWorkManager;
@property(nonatomic,strong)NetTypeModel          * netModelManager;

@end
@implementation AduroSmartSDK

+(AduroSmartSDK*)sharedManager{

    static AduroSmartSDK * sdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk = [[AduroSmartSDK alloc] init];
    });
    return sdk;
    
}
-(instancetype)init{

    if (self =[super init]) {
        [self initGlobalData];
        [self startNetCheck];
        [self startUDPClient];
        [self startMQTTClient];
    }
    return self;
}

-(void)initGlobalData{
    self.netModelManager = [[NetTypeModel alloc] init];
    [self.netModelManager addObserver:self forKeyPath:@"netModel" options: NSKeyValueObservingOptionNew context:nil];
}
-(void)startUDPClient{
    
    _udpClient         = [LeeUDPClientManager sharedManager];
    _udpClient.udpPort = Lee_BROADCAST_PORT;
    [_udpClient startUDPClientWithFeedBackBlock:^(id data) {

        [self AnalysisData:data withNetModel:self.netModelManager];
        
    } andError:^(NSError *error) {
        DLog(@"back-->>%@",error);
    }];
    
}
-(void)startMQTTClient{
    
    _mqttClient       = [LeeMQTTClientManager sharedManager];
    _mqttClient.topic = @"B9A6ED6F2DE115BC";
    if (![_mqttClient mqttConnect]) {
        _mqttClient.delegate = self;
        _mqttClient.host     = Lee_MQTT_HOST;
        [_mqttClient startMQTTClientAndSuccess:^(AduroSmartLinkCode code) {
            MLog(@"mqtt code -->%ld",(long)code);
            if (code == AduroSmartLinkSuccess) {
                GlobalConnectStatus = NetTypeRemote;
            }else{
                GlobalConnectStatus = NetTypeLocal;
            }
            self.netModelManager.netModel = GlobalConnectStatus;
        } andReceiveDataBlock:^(id data) {

            [self AnalysisData:data withNetModel:self.netModelManager];
            
        } andErrorBlock:^(NSError *error) {
            MLog(@"mqtt error -->%@",error);
        }];
    }
    
}
-(void)startNetCheck{

    self.netWorkManager = [Reachability reachabilityWithHostName:Lee_LINE_HOST];
    [self.netWorkManager startNotifier];
    [self netStatusChange:[_netWorkManager currentReachabilityStatus]];
    [Lee_Notification addObserver:self selector:@selector(networkChanged:)name:kReachabilityChangedNotification   object:nil];
    [Lee_Notification addObserver:self selector:@selector(tcpEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [Lee_Notification addObserver:self selector:@selector(tcpEnterForGround) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}
-(void)tcpEnterBackGround{

    
}
-(void)tcpEnterForGround{


    
}

-(void)checkNet{

    
}
-(void)networkChanged:(NSNotification*)notification{

    [self netStatusChange:[self.netWorkManager currentReachabilityStatus]];
}

#pragma reachable 网络监测
-(void)netStatusChange:(NetworkStatus )status{
    switch (status){
           
        case NotReachable:{
            NETLog(@"网络不可用");
            self.netModelManager.netModel = NetTypeUnreachble;
            break;
        }
        case ReachableViaWWAN:{
            NETLog(@"移动网络上网");
            self.netModelManager.netModel = NetTypeRemote;
            break;
        }
        case ReachableViaWiFi:{
            NETLog(@"wifi网络上网");
            self.netModelManager.netModel = NetTypeRemote;
            break;
        }
        default:
            break;
    }
}
/**
 监听网络状态变化
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"netModel"]) {
        NetType statue = [[change valueForKey:@"new"] intValue];
        switch (statue) {
            case NetTypeLocal:{
                GlobalConnectStatus = NetTypeLocal;
                NETLog(@"local...net");
                [Lee_Notification postNotificationName:Lee_Local_or_Remote object:nil];
            }
                break;
            case NetTypeRemote:{
                GlobalConnectStatus = NetTypeRemote;
                NETLog(@"remote...net");
                [Lee_Notification postNotificationName:Lee_Local_or_Remote object:nil];
            }
                break;
            case NetTypeUnreachble:{
                NETLog(@"unreachble...net");
                GlobalConnectStatus = NetTypeUnreachble;
            }
                break;
            default:
                break;
        }
    }
    
}

-(void)receiveMqttMsg:(id)data{
//    MLog(@"%@",data);
}

@end
