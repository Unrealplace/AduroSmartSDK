//
//  UserManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/25.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "UserManager.h"
#import "AduroGCDAsyncSocket.h"
#import "AduroGCDAsyncUdpSocket.h"
#import "AduroUser.h"

@implementation UserManager
+(UserManager*)sharedManager{
    
    static UserManager * device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[UserManager alloc] init];
    });
    return device;
}
@end
