//
//  SceneManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "SceneManager.h"
#import "AduroScene.h"

@implementation SceneManager
+(SceneManager*)sharedManager{
    
    static SceneManager * device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[SceneManager alloc] init];
    });
    return device;
}
@end
