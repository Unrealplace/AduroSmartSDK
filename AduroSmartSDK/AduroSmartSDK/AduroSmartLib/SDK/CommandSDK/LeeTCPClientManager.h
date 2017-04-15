//
//  LeeTCPClientManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/15.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface LeeTCPClientManager : LeeCommonObject
@property(nonatomic,assign)BOOL tcpConnect;

+(LeeTCPClientManager*)sharedManager;

-(BOOL)startTCPClientWithHost:(NSString*)host andPort:(uint16_t)port;

-(void)sendData:(NSData*)commandData WithReciveDataBlock:(LeeGetDataBlock) tcpGetDataBlock andError:(LeeGetErrorBlock) tcpGetErrorBlokck;

@end
