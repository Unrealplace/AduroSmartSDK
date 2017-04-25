//
//  TaskManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
@class AduroTask;

typedef void (^LeeGetTaskListBlock)(AduroTask*task);

@interface TaskManager : LeeCommonObject

+(TaskManager*)sharedManager;

/**
 添加一个任务

 @param task 要添加的任务
 @param completionHander 添加任务反馈结果
 */
-(void)addATask:(AduroTask*)task and:(LeeTaskStatusBlock)completionHander;

/**
 删除一个任务

 @param task 要删除的任务
 @param completionHander 删除任务反馈结果
 */
-(void)deleteTask:(AduroTask*)task and:(LeeTaskStatusBlock)completionHander;

/**
 修改任务

 @param task 要修改的任务
 @param completionHander 修个任务反馈结果
 */
-(void)changeTask:(AduroTask*)task and:(LeeTaskStatusBlock)completionHander;

/**
 获取任务列表

 @param completionHander 获取任务的反馈结果
 */
-(void)getTaskListand:(LeeGetTaskListBlock)completionHander;

/**
 获取一个任务

 @param task 要获取的任务
 @param completionHander 获取任务的反馈结果
 */
-(void)getTask:(AduroTask*)task and:(LeeTaskStatusBlock)completionHander;


@end
