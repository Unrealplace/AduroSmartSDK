//
//  LeeMQTTManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeMQTTClientManager.h"
#import "MQTTKit.h"
#import <UIKit/UIKit.h>

@interface LeeMQTTClientManager(){
    
    LeeAduroMQTTGetErrorBlock _errorBlock;
    LeeAduroMQTTGetDataBlock  _dataBlock;
    LeeAduroMQTTLinkSuccessBlock     _linkCodeBlock;
}
@property(nonatomic,strong)MQTTClient * mqttClient;
@end
@implementation LeeMQTTClientManager
+(LeeMQTTClientManager*)sharedManager{
    static LeeMQTTClientManager * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[LeeMQTTClientManager alloc] init];
    });
    return client;
}

-(void)startMQTTClientAndSuccess:(LeeAduroMQTTLinkSuccessBlock)linkCodeBlock andReceiveDataBlock:(LeeAduroMQTTGetDataBlock)receiveDataBlock andErrorBlock:(LeeAduroMQTTGetErrorBlock)errorBlock{
    
    NSString * clientID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    if (!_mqttClient) {
        _mqttClient = [[MQTTClient alloc] initWithClientId:clientID];
    }
    if (_mqttConnect) {
        return;
    }
    if (self.topic ==nil) {
        return;
    }
    _linkCodeBlock = linkCodeBlock;
    _dataBlock     = receiveDataBlock;
    _errorBlock    = errorBlock;
    __weak LeeMQTTClientManager *weakSelf = self;
    if (_mqttClient.messageHandler == nil) {
        [_mqttClient setMessageHandler:^(MQTTMessage * message){
            __strong typeof(self) strongSelf = weakSelf;
            NSInteger mid = message.mid;
            NSNumber *midNumber = [NSNumber numberWithInteger:mid];
            NSString *topic = message.topic;
            NSData *payload = message.payload;
            BOOL retained = message.retained;
            NSNumber *retainedNumber = [NSNumber numberWithBool:retained];
            if (payload) {
                NSDictionary *dataDict = [[NSDictionary alloc]initWithObjectsAndKeys:midNumber,@"mid",topic,@"topic",payload,@"data",retainedNumber,@"retained",weakSelf.host,@"ip", nil];
                if (strongSelf->_dataBlock) {
                    strongSelf->_dataBlock(dataDict);
                }
                [weakSelf.delegate receiveMqttMsg:dataDict];
            }
        }];
    }
    [self connect];
}
-(void)connect{
    
    if (self.host) {
        [_mqttClient connectToHost:self.host completionHandler:^(MQTTConnectionReturnCode code) {
            if (code == ConnectionAccepted) {
                _mqttConnect = YES;
                if (self.topic) {
                    [_mqttClient subscribe:self.topic withQos:ExactlyOnce completionHandler:^(NSArray *grantedQos) {
                    }];
                }
                if (_linkCodeBlock) {
                    _linkCodeBlock(AduroSmartLinkSuccess);
                }
            }else{
                _mqttConnect = NO;
                if (_linkCodeBlock) {
                    _linkCodeBlock(AduroSmartLinkFailed);
                }
            }
        }];
    }
    
}
-(void)stopMQTTClient{
    
    if (_mqttClient) {
        [_mqttClient disconnectWithCompletionHandler:^(NSUInteger code) {
            _mqttConnect = NO;
            [_mqttClient clearWill];
            
        }];
    }
}
-(void)mqttSendCommandData:(NSData *)commandData andReceiveDataBlock:(LeeAduroMQTTGetDataBlock)receiveDataBlock andErrorBlock:(LeeAduroMQTTGetErrorBlock)errorBlock{
    
    if (_mqttClient) {
        if (!_mqttConnect) {
            [self connect];
        }else{
            
            _dataBlock     = receiveDataBlock;
            _errorBlock    = errorBlock;
            
            [_mqttClient publishData:commandData toTopic:self.topic withQos:AtLeastOnce retain:YES completionHandler:^(int mid) {
                NSLog(@"mid--->>>%d",mid);
            }];
        }
    }else{
        [self stopMQTTClient];
        [self startMQTTClientAndSuccess:nil andReceiveDataBlock:nil andErrorBlock:nil];
    }
}
@end
