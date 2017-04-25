//
//  DeviceManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//


#import "LeeCommonObject.h"
#import "AduroDevice.h"
typedef void(^LeeGetDevicesBlock)(AduroDevice *device);

@interface DeviceManager : LeeCommonObject
+(DeviceManager*)sharedManager;


-(void)findNewDevices:(LeeGetDevicesBlock)devices;

/**
 添加一个设备
 @param completionHandler 添加结果
 */
-(void)addADevice:(LeeDeviceStatusBlock)completionHandler;

/**
 删除一个设备

 @param device 要删除的设备
 @param completionHandler 删除结果反馈
 */
-(void)deleteDevice:(AduroDevice*)device and:(LeeDeviceStatusBlock)completionHandler;


/**
 修改设备信息

 @param device 要修改的设备
 @param completionHandler 修改结果反馈
 */
-(void)changeDeviceInfo:(AduroDevice*)device and:(LeeDeviceStatusBlock)completionHandler;


/**
 控制设备

 @param device 要控制的设备
 @param completionHandler 控制结果反馈
 */
-(void)controlDevice:(AduroDevice*)device and:(LeeDeviceStatusBlock)completionHandler;

/**
 识别一个设备

 @param device 要识别的设备
 @param completionHandler 识别结果反馈
 */
-(void)identifyDevice:(AduroDevice*)device and:(LeeDeviceStatusBlock)completionHandler;


/**
 获取所有在线设备

 @param devices 反馈获取结果
 */
-(void)getAllDevices:(LeeGetDevicesBlock)devices;



@end
