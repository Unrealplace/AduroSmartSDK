//
//  GatewayManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/13.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "GatewayManager.h"
#import "LeeUDPClientManager.h"

@interface GatewayManager(){
    AllGatewaysInLanBlock _allGetGatewayBlock;
    
}

@end
@implementation GatewayManager

+ (GatewayManager *)sharedManager
{
    static GatewayManager *sharedGatewayManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGatewayManagerInstance = [[self alloc] init];
    });
    return sharedGatewayManagerInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [Lee_Notification addObserver:self selector:@selector(getGateWay:) name:GET_GATEWAY object:nil];
        //        //查找到局域网网关
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadGatewayObject:) name:@"uploadGatewayObject" object:nil];
//        //获得网关的软件版本号
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadGatewayVersion:) name:@"GetGatewayVersionBlock" object:nil];
//        //@"HeartbeatResultNoti"
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heartbeatResultNoti:) name:@"HeartbeatResultNoti" object:nil];
//        //网关内域名
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGatewayDomainNoti:) name:@"GetGatewayDomainNoti" object:nil];
//        //网关firmware每包数据大小
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upgradePackageSizeNoti:) name:@"UpgradePackageSizeNoti" object:nil];
//        //上一包发送的数据
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upgradePackageIndexNoti:) name:@"UpgradePackageIndexNoti" object:nil];
        
    }
    return self;
}
-(void)getGateWay:(NSNotification*)nofi{

    _allGetGatewayBlock(@[nofi.object]);
    
}
-(void)searchGateways:(AllGatewaysInLanBlock)gateways{
    _allGetGatewayBlock = gateways;
    
    
}
@end
