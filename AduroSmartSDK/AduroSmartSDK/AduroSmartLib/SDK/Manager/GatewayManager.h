//
//  GatewayManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/13.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
typedef void (^AllGatewaysInLanBlock)(NSArray* gateways);

@interface GatewayManager : LeeCommonObject

+ (GatewayManager *)sharedManager;

-(void)searchGateways:(AllGatewaysInLanBlock)gateways;
@end
