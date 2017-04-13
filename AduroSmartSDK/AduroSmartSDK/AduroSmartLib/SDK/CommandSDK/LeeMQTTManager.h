//
//  LeeMQTTManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum:NSInteger{
    AduroSmartLinkFailed,
    AduroSmartLinkSuccess
    
}AduroSmartLinkCode;
@protocol mqttConnectDelegate <NSObject>

@optional
-(void)receiveMqttMsg:(id)data;

@end
typedef void (^AduroMQTTGetDataBlock)(id data);
typedef void (^AduroMQTTGetErrorBlock)(NSError*error);
typedef void (^AduroMQTTLinkSuccessBlock)(AduroSmartLinkCode code);

@interface LeeMQTTManager : NSObject

@property(nonatomic,copy)NSString * topic;
@property(nonatomic,copy)NSString * host;
@property(nonatomic,assign)BOOL   mqttConnect;
@property(nonatomic,assign)id<mqttConnectDelegate>delegate;

+(instancetype)sharedManager;
-(void)startMQTTClientAndSuccess:(AduroMQTTLinkSuccessBlock) linkCodeBlock andReceiveDataBlock:(AduroMQTTGetDataBlock) receiveDataBlock andErrorBlock:(AduroMQTTGetErrorBlock) errorBlock;
-(void)stopMQTTClient;
-(void)mqttSendCommandData:(NSData*)commandData andReceiveDataBlock:(AduroMQTTGetDataBlock) receiveDataBlock andErrorBlock:(AduroMQTTGetErrorBlock) errorBlock;

@end
