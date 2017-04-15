//
//  LeeUDPClientManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//


#import "LeeCommonObject.h"

typedef void (^AduroUDPReceiveDataBlock)(NSData*data);
typedef void (^AduroUDPReceiveErrorBlock)(NSError*error);

@interface LeeUDPClientManager : LeeCommonObject

@property(nonatomic,assign)uint16_t udpPort;
@property(nonatomic,copy)NSString  *host;
@property(nonatomic,assign)BOOL udpConnect;

+(instancetype)sharedManager;
-(void)closeUDPClient; 
-(BOOL)startUDPClientWithFeedBackBlock:(AduroUDPReceiveDataBlock)receiveDataBlock andError:(AduroUDPReceiveErrorBlock) errorBlock;
-(void)sendData:(NSData*)commandData andReceiveData:(AduroUDPReceiveDataBlock) receiveDataBlock andError:(AduroUDPReceiveErrorBlock) errorBlock;

@end
