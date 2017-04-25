//
//  AduroGroup.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface AduroGroup : LeeCommonObject
@property(nonatomic,assign)UInt16 groupID;//房间序号
@property(nonatomic,assign)AduroGroupType groupType;//房间类型
@property(nonatomic,copy)NSString * groupName;//房间名称
@property(nonatomic,assign)Byte  deviceCount;//房间中的设备数量
@property(nonatomic,assign)Byte status;//开关状态
@property(nonatomic,assign)Byte level;//亮度
@property(nonatomic,assign)UInt16 clrTem;//色温
@property(nonatomic,assign)UInt16 Xclr;//颜色范围X
@property(nonatomic,assign)UInt16 Yclr;//颜色范围Y
@property(nonatomic,strong)NSMutableArray* groupDeviceIDArr;//房间中的设备序号集合
@end
