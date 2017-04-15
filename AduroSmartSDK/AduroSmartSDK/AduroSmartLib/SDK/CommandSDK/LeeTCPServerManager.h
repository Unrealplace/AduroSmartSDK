//
//  LeeTCPServerManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/15.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface LeeTCPServerManager : LeeCommonObject

-(void)startServerOnPort:(uint16_t)port;

@end
