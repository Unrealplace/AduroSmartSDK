//
//  RealReachability.h
//  Version 1.1.0
//
//  Created by Dustturtle on 16/1/9.
//  Copyright (c) 2016 Dustturtle. All rights reserved.
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#define GLobalAduroRealReachability [AduroRealReachability sharedInstance]

///This notification was called only when reachability really changed;
///We use FSM to promise this for you;
///We post self to this notification, then you can invoke currentReachabilityStatus method to fetch current status.
extern NSString *const kAduroRealReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, AduroReachabilityStatus) {
    ///Direct match with Apple networkStatus, just a force type convert.
    AduroRealStatusUnknown = -1,
    AduroRealStatusNotReachable = 0,
    AduroRealStatusViaWWAN = 1,
    AduroRealStatusViaWiFi = 2
};

typedef NS_ENUM(NSInteger, AduroWWANAccessType) {
    AduroWWANTypeUnknown = -1, /// maybe iOS6
    AduroWWANType4G = 0,
    AduroWWANType3G = 1,
    AduroWWANType2G = 3
};

@interface AduroRealReachability : NSObject

/// Please make sure this host is available for pinging! default host:www.baidu.com
@property (nonatomic, copy) NSString *hostForPing;

/// Interval in minutes; default is 2.0f, suggest value from 0.3f to 60.0f;
/// If exceeded, the value will be reset to 0.3f or 60.0f (the closer one).
@property (nonatomic, assign) float autoCheckInterval;

// Timeout used for ping. Default is 2 seconds
@property (nonatomic, assign) NSTimeInterval pingTimeout;

+ (instancetype)sharedInstance;

- (void)startNotifier;

- (void)stopNotifier;

/**
 *  To get real reachability we need to do async request,
 *  then we use the block blow for invoker to handle business request(need real reachability).
 *
 *  @param asyncHandler async request handler, return in 2 seconds(max limit).
 */
- (void)reachabilityWithBlock:(void (^)(AduroReachabilityStatus status))asyncHandler;

/**
 *  Return current reachability immediately.
 *
 *  @return see enum LocalConnectionStatus
 */
- (AduroReachabilityStatus)currentReachabilityStatus;

/**
 *  Return previous reachability status.
 *
 *  @return see enum LocalConnectionStatus
 */
- (AduroReachabilityStatus)previousReachabilityStatus;

/**
 *  Return current WWAN type immediately.
 *
 *  @return unknown/4g/3g/2g.
 *
 *  This method can be used to improve app's further network performance
 *  (different strategies for different WWAN types).
 */
- (AduroWWANAccessType)currentWWANtype;

@end
