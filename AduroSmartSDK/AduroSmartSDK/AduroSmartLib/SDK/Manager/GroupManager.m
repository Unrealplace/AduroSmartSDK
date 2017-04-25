//
//  GroupManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "GroupManager.h"
#import "AduroGroup.h"

@implementation GroupManager
+(GroupManager*)sharedManager{
    
    static GroupManager * device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[GroupManager alloc] init];
    });
    return device;
}
@end
