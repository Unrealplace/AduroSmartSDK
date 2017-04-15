//
//  NSString+GetIPAddress.h
//  AduroSmartFrameWork
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetIPAddress)

+ (NSString *)getLocalIP;

+ (NSString *) getDeviceSSID;

+ (NSString *)getWifiName;

@end
