//
//  AduroDevice.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
@interface AduroDevice : LeeCommonObject

@property(nonatomic,copy)NSString * data;


@property(nonatomic,copy)NSString * deviceName;//设备名
@property (nonatomic, assign)AduroDeviceType deviceTypeID; //设备种类,见枚举DeviceTypeID

//调光灯
@property(nonatomic,assign)Byte  openOrClose;//开关 开关状态，0-关闭，1-打开
@property(nonatomic,assign)Byte  lightLevel;//亮度 亮度，范围 0~255

@property(nonatomic, assign)UInt16 deviceLightColorTemperature; //色温灯的色温值 色温值，范围[153~500]

@property(nonatomic, assign)UInt16 deviceLightX; //颜色属性X 颜色值，范围 0~65535
@property(nonatomic, assign)UInt16 deviceLightY; //颜色属性Y 颜色值，范围 0~65535

@property(nonatomic,assign)Byte doorCtrl;//Bit0:推送开关，0-不推送，1-推送 Bit1:设防开关，0-撤防，1-设防
@property(nonatomic,assign)Byte doorStatus;//开关状态，0-关闭，1-打开
@property(nonatomic,assign)Byte doorPowerLevel;//电量，范围 0~100

@property(nonatomic,assign)Byte pirCtrl;//Bit0:推送开关，0-不推送，1-推送 Bit1:设防开关，0-撤防，1-设防
@property(nonatomic,assign)Byte pirStatus;//检查的到人触发，0-无人，1-有人
@property(nonatomic,assign)Byte pirPowerLevel;//电量，范围 0~100


@end
