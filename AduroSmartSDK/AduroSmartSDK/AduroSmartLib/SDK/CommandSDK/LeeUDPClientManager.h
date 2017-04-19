//
//  LeeUDPClientManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//


#import "LeeCommonObject.h"


@interface LeeUDPClientManager : LeeCommonObject

@property(nonatomic,assign)uint16_t udpPort;
@property(nonatomic,copy)NSString  *host;
@property(nonatomic,assign)BOOL udpConnect;

+(instancetype)sharedManager;
-(void)closeUDPClient; 
-(BOOL)startUDPClientWithFeedBackBlock:(LeeAduroUDPReceiveDataBlock)receiveDataBlock andError:(LeeAduroUDPReceiveErrorBlock) errorBlock;
-(void)sendData:(NSData*)commandData andReceiveData:(LeeAduroUDPReceiveDataBlock) receiveDataBlock andError:(LeeAduroUDPReceiveErrorBlock) errorBlock;

@end
