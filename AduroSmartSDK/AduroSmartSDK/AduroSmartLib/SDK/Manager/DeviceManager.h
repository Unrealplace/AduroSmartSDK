//
//  DeviceManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AduroDevice.h"


typedef void(^GetDevicesBlock)(AduroDevice *device);

@interface DeviceManager : NSObject
+(DeviceManager*)sharedManager;


-(void)findNewDevices:(GetDevicesBlock)devices;

-(void)getAllDevices:(GetDevicesBlock)devices;

@end
