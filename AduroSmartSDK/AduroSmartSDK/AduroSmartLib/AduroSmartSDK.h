//
//  AduroSmartSDK.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
#import "GatewayManager.h"
#import "DeviceManager.h"
#import "GroupManager.h"
#import "TaskManager.h"
#import "UserManager.h"
#import "SceneManager.h"

#import "AduroDevice.h"
#import "AduroGateway.h"
#import "AduroGroup.h"
#import "AduroTask.h"
#import "AduroUser.h"
#import "AduroScene.h"

@interface AduroSmartSDK : LeeCommonObject

+(AduroSmartSDK*)sharedManager;


@end
