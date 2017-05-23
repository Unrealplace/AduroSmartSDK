//
//  TaskManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "TaskManager.h"
#import "AduroGCDAsyncSocket.h"
#import "AduroGCDAsyncUdpSocket.h"
#import "AduroTask.h"

@implementation TaskManager
+(TaskManager*)sharedManager{
    
    static TaskManager * device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[TaskManager alloc] init];
    });
    return device;
}
@end
