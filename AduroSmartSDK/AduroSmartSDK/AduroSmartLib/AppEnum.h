//
//  AppEnum.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - Debug日志
#ifdef DEBUG
#    define  DLog(...) printf("udp**%s**\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String])
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

@interface AppEnum : NSObject

@end
