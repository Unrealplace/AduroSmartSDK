//
//  LeeUDPServerManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/15.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface LeeUDPServerManager : LeeCommonObject

-(void)startUDPServerWithPort:(uint16_t)port;
-(void)sendBroadCast;
- (void)sendCommandAndRecieveData:(LeeGetDataBlock) udpServerGetDataBlock;

@end
