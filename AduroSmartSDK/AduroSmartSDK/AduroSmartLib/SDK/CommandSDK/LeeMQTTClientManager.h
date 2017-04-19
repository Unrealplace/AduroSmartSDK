//
//  LeeMQTTManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@protocol mqttConnectDelegate <NSObject>

@optional
-(void)receiveMqttMsg:(id)data;

@end

@interface LeeMQTTClientManager : LeeCommonObject

@property(nonatomic,copy)NSString * topic;
@property(nonatomic,copy)NSString * host;
@property(nonatomic,assign)BOOL   mqttConnect;
@property(nonatomic,assign)id<mqttConnectDelegate>delegate;

+(LeeMQTTClientManager*)sharedManager;
-(void)startMQTTClientAndSuccess:(LeeAduroMQTTLinkSuccessBlock) linkCodeBlock andReceiveDataBlock:(LeeAduroMQTTGetDataBlock) receiveDataBlock andErrorBlock:(LeeAduroMQTTGetErrorBlock) errorBlock;
-(void)stopMQTTClient;
-(void)mqttSendCommandData:(NSData*)commandData andReceiveDataBlock:(LeeAduroMQTTGetDataBlock) receiveDataBlock andErrorBlock:(LeeAduroMQTTGetErrorBlock) errorBlock;

@end
