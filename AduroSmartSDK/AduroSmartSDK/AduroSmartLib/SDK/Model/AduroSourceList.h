//
//  AduroSourceList.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/25.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface AduroSourceList : LeeCommonObject

@property(nonatomic,assign)Byte devCount;    //设备列表的数量 max 100
@property(nonatomic,assign)Byte groupCount; //房间列表的数量  max 50
@property(nonatomic,assign)Byte sceneCount;//场景列表的数量   max 50
@property(nonatomic,assign)Byte taskCount;//任务列表的数量    max 50
@property(nonatomic,assign)Byte userCount;//网关中已经加入的用户数量 max 10

@end
