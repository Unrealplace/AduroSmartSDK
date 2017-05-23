//
//  AduroTask.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface AduroTask : LeeCommonObject

@property(nonatomic,assign)UInt16 taskID;//任务ID
@property(nonatomic,copy)NSString * taskName;//任务名称
@property(nonatomic,assign)Byte taskCount;//任务数
@property(nonatomic,assign)BOOL taskON_OFF;//触发开关
@property(nonatomic,assign)AduroTaskType taskType;//任务类型
//事件触发
@property(nonatomic,assign)UInt16 deviceID;//事件触发的设备id
@property(nonatomic,assign)UInt16 deviceValue;//触发任务的状态：0关，1开，pir时候，1有人。
@property(nonatomic,assign)Byte   devOperator;//操作符

//时间触发
@property(nonatomic,assign)Byte taskWeek;//周期，b0 周一，。。。
@property(nonatomic,assign)Byte taskHour;//小时，采用24小时制
@property(nonatomic,assign)Byte taskMin;//分钟
@property(nonatomic,strong)NSMutableArray * taskDevIDArr;//要触发的任务包含的设备或者场景

@end
