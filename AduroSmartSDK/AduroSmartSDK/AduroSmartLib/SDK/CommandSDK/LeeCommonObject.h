//
//  LeeCommonObject.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/15.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AduroGCDAsyncSocket.h"
#import "AduroGCDAsyncUdpSocket.h"
#pragma mark - Debug日志
#ifdef DEBUG
#    define  DLog(...) printf("**%s**\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String])
#    define  FLog(s)   NSLog(@"[%@-%@]:\n%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),s)
#    define  MLog(...) printf("mqtt**%s**\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String])

#    define TLog(...)  NSLog(@"[%@-%@]:\n%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),[NSString stringWithFormat:__VA_ARGS__])
#else
#    define DLog(...)
#    define MLog(...)
#    define FLog(...)
#    define TLog(...)
#endif
#define BROADCAST_PORT 8888
#define MQTT_HOST @"data.adurosmart.com"
#define GET_GATEWAY @"getgateway"
#define Lee_Notification  [NSNotificationCenter defaultCenter]
#define Lee_Userdefault   [NSUserDefaults standardUserDefaults]
#define Lee_Staus @"Statu"

typedef void (^LeeGetDataBlock)(id data);
typedef void (^LeeGetErrorBlock)(NSError* error);
extern BOOL IsRemoteConnect;

@interface LeeCommonObject : NSObject

@property(nonatomic,strong)NSError * commonError;
@property(nonatomic,assign)BOOL      commentResult;

@end
