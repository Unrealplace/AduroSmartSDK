//
//  RealReachability.m
//  RealReachability
//
//  Created by Dustturtle on 16/1/9.
//  Copyright © 2016 Dustturtle. All rights reserved.
//

#import "AduroRealReachability.h"
#import "AduroFSMEngine.h"
#import "AduroLocalConnection.h"
#import "AduroPingHelper.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#if (!defined(DEBUG))
#define NSLog(...)
#endif

#define kDefaultHost @"www.baidu.com"
#define kDefaultCheckInterval 2.0f
#define kDefaultPingTimeout 2.0f

#define kMinAutoCheckInterval 0.3f
#define kMaxAutoCheckInterval 60.0f

NSString *const kAduroRealReachabilityChangedNotification = @"kRealReachabilityChangedNotification";

@interface AduroRealReachability()
@property (nonatomic, strong) AduroFSMEngine *engine;
@property (nonatomic, assign) BOOL isNotifying;

@property (nonatomic,strong) NSArray *typeStrings4G;
@property (nonatomic,strong) NSArray *typeStrings3G;
@property (nonatomic,strong) NSArray *typeStrings2G;

@property (nonatomic, assign) AduroReachabilityStatus previousStatus;
@end

@implementation AduroRealReachability

#pragma mark - Life Circle

- (id)init
{
    if ((self = [super init]))
    {
        _engine = [[AduroFSMEngine alloc] init];
        [_engine start];
        
        _typeStrings2G = @[CTRadioAccessTechnologyEdge,
                           CTRadioAccessTechnologyGPRS,
                           CTRadioAccessTechnologyCDMA1x];
        
        _typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                           CTRadioAccessTechnologyWCDMA,
                           CTRadioAccessTechnologyHSUPA,
                           CTRadioAccessTechnologyCDMAEVDORev0,
                           CTRadioAccessTechnologyCDMAEVDORevA,
                           CTRadioAccessTechnologyCDMAEVDORevB,
                           CTRadioAccessTechnologyeHRPD];
        
        _typeStrings4G = @[CTRadioAccessTechnologyLTE];
        
        _hostForPing = kDefaultHost;
        _autoCheckInterval = kDefaultCheckInterval;
        _pingTimeout = kDefaultPingTimeout;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.engine = nil;
    
    [GAduroLocalConnection stopNotifier];
}

#pragma mark - Handle system event

- (void)appBecomeActive
{
    if (self.isNotifying)
    {
        [self reachabilityWithBlock:nil];
    }
}

#pragma mark - Singlton Method

+ (instancetype)sharedInstance
{
    static id localConnection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localConnection = [[self alloc] init];
    });
    
    return localConnection;
}

#pragma mark - actions

- (void)startNotifier
{
    if (self.isNotifying)
    {
        // avoid duplicate action
        return;
    }
    
    self.isNotifying = YES;
    self.previousStatus = AduroRealStatusUnknown;
    
    NSDictionary *inputDic = @{kEventKeyID:@(RREventLoad)};
    [self.engine receiveInput:inputDic];
    
    [GAduroLocalConnection startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localConnectionChanged:)
                                                 name:kAduroLocalConnectionChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localConnectionInitialized:)
                                                 name:kAduroLocalConnectionInitializedNotification
                                               object:nil];
    
    GAduroPingHelper.host = _hostForPing;
    GAduroPingHelper.timeout = self.pingTimeout;
    [self autoCheckReachability];
}

- (void)stopNotifier
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kAduroLocalConnectionChangedNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kAduroLocalConnectionInitializedNotification
                                                  object:nil];
    
    NSDictionary *inputDic = @{kEventKeyID:@(RREventUnLoad)};
    [self.engine receiveInput:inputDic];
    
    [GAduroLocalConnection stopNotifier];
    
    self.isNotifying = NO;
}

#pragma mark - outside invoke

- (void)reachabilityWithBlock:(void (^)(AduroReachabilityStatus status))asyncHandler
{
    // logic optimization: no need to ping when Local connection unavailable!
    if ([GAduroLocalConnection currentLocalConnectionStatus] == LC_UnReachable)
    {
        if (asyncHandler != nil)
        {
            asyncHandler(AduroRealStatusNotReachable);
        }
        return;
    }
    
    AduroReachabilityStatus status = [self currentReachabilityStatus];
    __weak __typeof(self)weakSelf = self;
    [GAduroPingHelper pingWithBlock:^(BOOL isSuccess)
     {
         __strong __typeof(weakSelf)strongSelf = weakSelf;
         NSDictionary *inputDic = @{kEventKeyID:@(RREventPingCallback), kEventKeyParam:@(isSuccess)};
         NSInteger rtn = [strongSelf.engine receiveInput:inputDic];
         if (rtn == 0) // state changed & state available, post notification.
         {
             if ([strongSelf.engine isCurrentStateAvailable])
             {
                 strongSelf.previousStatus = status;
                 // this makes sure the change notification happens on the MAIN THREAD
                 __weak __typeof(strongSelf)deepWeakSelf = strongSelf;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     __strong __typeof(deepWeakSelf)deepStrongSelf = deepWeakSelf;
                     [[NSNotificationCenter defaultCenter] postNotificationName:kAduroRealReachabilityChangedNotification
                                                                         object:deepStrongSelf];
                 });
             }
         }
         
         if (asyncHandler != nil)
         {
             RRStateID currentID = strongSelf.engine.currentStateID;
             switch (currentID)
             {
                 case RRStateUnReachable:
                 {
                     asyncHandler(AduroRealStatusNotReachable);
                     break;
                 }
                 case RRStateWIFI:
                 {
                     asyncHandler(AduroRealStatusViaWiFi);
                     break;
                 }
                 case RRStateWWAN:
                 {
                     asyncHandler(AduroRealStatusViaWWAN);
                     break;
                 }
                     
                 default:
                 {
                     NSLog(@"warning! reachState uncertain! state unmatched, treat as unreachable temporary");
                     asyncHandler(AduroRealStatusNotReachable);
                     break;
                 }
             }
         }
     }];
}

- (AduroReachabilityStatus)currentReachabilityStatus
{
    RRStateID currentID = self.engine.currentStateID;
    
    switch (currentID)
    {
        case RRStateUnReachable:
        {
            return AduroRealStatusNotReachable;
        }
        case RRStateWIFI:
        {
            return AduroRealStatusViaWiFi;
        }
        case RRStateWWAN:
        {
            return AduroRealStatusViaWWAN;
        }
        case RRStateLoading:
        {
            // status on loading, return local status temporary.
            return (AduroReachabilityStatus)(GAduroLocalConnection.currentLocalConnectionStatus);
        }
            
        default:
        {
            NSLog(@"No normal status matched, return unreachable temporary");
            return AduroRealStatusNotReachable;
        }
    }
}

- (AduroReachabilityStatus)previousReachabilityStatus
{
    return self.previousStatus;
}

- (void)setHostForPing:(NSString *)hostForPing
{
    _hostForPing = nil;
    _hostForPing = [hostForPing copy];
    
    GAduroPingHelper.host = _hostForPing;
}

- (void)setPingTimeout:(NSTimeInterval)pingTimeout {
    _pingTimeout = pingTimeout;
    GAduroPingHelper.timeout = pingTimeout;
}

- (AduroWWANAccessType)currentWWANtype
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([accessString length] > 0)
        {
            return [self accessTypeForString:accessString];
        }
        else
        {
            return AduroWWANTypeUnknown;
        }
    }
    else
    {
        return AduroWWANTypeUnknown;
    }
}

#pragma mark - inner methods
- (NSString *)paramValueFromStatus:(LocalConnectionStatus)status
{
    switch (status)
    {
        case LC_UnReachable:
        {
            return kParamValueUnReachable;
        }
        case LC_WiFi:
        {
          return kParamValueWIFI;
        }
        case LC_WWAN:
        {
            return kParamValueWWAN;
        }
           
        default:
        {
            NSLog(@"RealReachability error! paramValueFromStatus not matched!");
            return @"";
        }
    }
}

// auto checking after every autoCheckInterval minutes
- (void)autoCheckReachability
{
    if (!self.isNotifying)
    {
        return;
    }
    
    if (self.autoCheckInterval < kMinAutoCheckInterval)
    {
        self.autoCheckInterval = kMinAutoCheckInterval;
    }
    
    if (self.autoCheckInterval > kMaxAutoCheckInterval)
    {
        self.autoCheckInterval = kMaxAutoCheckInterval;
    }
    
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoCheckInterval*60*NSEC_PER_SEC));
    __weak __typeof(self)weakSelf = self;
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf reachabilityWithBlock:nil];
        [strongSelf autoCheckReachability];
    });
}

- (AduroWWANAccessType)accessTypeForString:(NSString *)accessString
{
    if ([self.typeStrings4G containsObject:accessString])
    {
        return AduroWWANType4G;
    }
    else if ([self.typeStrings3G containsObject:accessString])
    {
        return AduroWWANType3G;
    }
    else if ([self.typeStrings2G containsObject:accessString])
    {
        return AduroWWANType2G;
    }
    else
    {
        return AduroWWANTypeUnknown;
    }
}

#pragma mark - Notification observer
- (void)localConnectionChanged:(NSNotification *)notification
{
    AduroLocalConnection *lc = (AduroLocalConnection *)notification.object;
    LocalConnectionStatus lcStatus = [lc currentLocalConnectionStatus];
    //NSLog(@"currentLocalConnectionStatus:%@",@(lcStatus));
    AduroReachabilityStatus status = [self currentReachabilityStatus];
    
    NSDictionary *inputDic = @{kEventKeyID:@(RREventLocalConnectionCallback), kEventKeyParam:[self paramValueFromStatus:lcStatus]};
    NSInteger rtn = [self.engine receiveInput:inputDic];
    
    if (rtn == 0) // state changed & state available, post notification.
    {
        if ([self.engine isCurrentStateAvailable])
        {
            self.previousStatus = status;
            // already in main thread.
            [[NSNotificationCenter defaultCenter] postNotificationName:kAduroRealReachabilityChangedNotification
                                                                object:self];
            
            if (lcStatus != LC_UnReachable)
            {
                // To make sure your reachability is "Real".
                [self reachabilityWithBlock:nil];
            }
        }
    }
}

- (void)localConnectionInitialized:(NSNotification *)notification
{
    AduroLocalConnection *lc = (AduroLocalConnection *)notification.object;
    LocalConnectionStatus lcStatus = [lc currentLocalConnectionStatus];
    NSLog(@"localConnectionInitializedStatus:%@",@(lcStatus));
    
    NSDictionary *inputDic = @{kEventKeyID:@(RREventLocalConnectionCallback), kEventKeyParam:[self paramValueFromStatus:lcStatus]};
    NSInteger rtn = [self.engine receiveInput:inputDic];
    
    // Initialized state, ping once to check the reachability(if local status reachable).
    if ((rtn == 0) && [self.engine isCurrentStateAvailable] && (lcStatus != LC_UnReachable))
    {
        // To make sure your reachability is "Real".
        [self reachabilityWithBlock:nil];
    }
}

@end

