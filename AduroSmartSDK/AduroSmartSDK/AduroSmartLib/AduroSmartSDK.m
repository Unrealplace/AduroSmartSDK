//
//  AduroSmartSDK.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "AduroSmartSDK.h"
#import "LeeUDPManager.h"
#import "LeeMQTTManager.h"
#import "AduroRealReachability.h"
#import "AppEnum.h"
#import "AduroGlobalData.h"


@interface AduroSmartSDK()<mqttConnectDelegate>

@property(nonatomic,strong)LeeUDPManager * udpClient;
@property(nonatomic,strong)LeeMQTTManager* mqttClient;
@property(nonatomic,strong)AduroRealReachability * netWorkManager;

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
        [self startUDPClient];
        [self startMQTTClient];
        
    }
    return self;
}
-(void)startUDPClient{
    
    _udpClient = [LeeUDPManager sharedManager];
    _udpClient.udpPort = BROADCAST_PORT;
    [_udpClient startUDPClientWithFeedBackBlock:^(NSData *data) {
        DLog(@"back-->>%@",data);
    } andError:^(NSError *error) {
        DLog(@"back-->>%@",error);
    }];
    
}
-(void)startMQTTClient{
    
    _mqttClient = [LeeMQTTManager sharedManager];
    _mqttClient.topic = @"B9A6ED6F2DE115BC";
    if (![_mqttClient mqttConnect]) {
        _mqttClient.delegate = self;
        _mqttClient.host     = MQTT_HOST;
        [_mqttClient startMQTTClientAndSuccess:^(AduroSmartLinkCode code) {
            MLog(@"mqtt code -->%ld",(long)code);
            if (code == AduroSmartLinkSuccess) {
                IsRemoteConnect = YES;
            }else{
            
                IsRemoteConnect = NO;
            }
        } andReceiveDataBlock:^(id data) {
            MLog(@"mqtt data -->%@",data);
        } andErrorBlock:^(NSError *error) {
            MLog(@"mqtt error -->%@",error);
        }];
    }
}

-(void)receiveMqttMsg:(id)data{
//    MLog(@"%@",data);
}

@end
