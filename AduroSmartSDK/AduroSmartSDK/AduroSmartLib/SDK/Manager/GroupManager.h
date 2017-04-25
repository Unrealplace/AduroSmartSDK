//
//  GroupManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
@class AduroGroup;
typedef void (^LeeGetGroupBlock)(AduroGroup *group);
@interface GroupManager : LeeCommonObject


+(GroupManager*)sharedManager;

/**
   添加一个房间

 @param group 房间
 @param completionHandler 添加反馈结果
 */
-(void)addAGroup:(AduroGroup*)group and:(LeeGroupStatusBlock)completionHandler;

/**
 删除一个房间

 @param group 要删除的房间
 @param completionHandler 删除结果反馈
 */
-(void)deleteGroup:(AduroGroup*)group and:(LeeGroupStatusBlock)completionHandler;

/**
 控制一个房间

 @param group 要控制的房间
 @param completionHandler 控制结果反馈
 */
-(void)controlGroup:(AduroGroup*)group and:(LeeGroupStatusBlock)completionHandler;

/**
 修改房间信息

 @param group 要修改的房间
 @param completionHandler 修改结果反馈
 */
-(void)changeGroupInfo:(AduroGroup*)group and:(LeeGroupStatusBlock)completionHandler;

/**
 获取房间列表

 @param completionHandler 获取反馈
 */
-(void)getGroupListand:(LeeGetGroupBlock)completionHandler;

/**
 获取某个房间

 @param group 要获取的房间
 @param completionHandler 获取结果反馈
 */
-(void)getGroup:(AduroGroup*)group and:(LeeGroupStatusBlock)completionHandler;


@end
