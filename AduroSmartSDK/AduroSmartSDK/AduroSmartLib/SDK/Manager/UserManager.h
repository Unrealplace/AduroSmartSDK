//
//  UserManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/25.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
@class AduroUser;
typedef void (^LeeGetAllUserBlock)(AduroUser * user);

@interface UserManager : LeeCommonObject

+(UserManager*)sharedManager;

/**
 添加一个用户

 @param user 用户信息
 @param completionHander 管理远授权给其他用户的操作指令
 */
-(void)addAUser:(AduroUser*)user and:(LeeUserStatusBlock) completionHander;

/**
 删除一个用户

 @param user 管理员用来删除用户或删除自己的操作，如果删除的是用户，用户失去控制权，删除的自己整个用户表被删除
 @param completionHander 删除结果反馈
 */
-(void)deleteUser:(AduroUser*)user and:(LeeUserStatusBlock) completionHander;

/**
 修改用户信息

 @param user 修改用户名称字符串，不能修改用户编码
 @param completionHander 修改结果反馈
 */
-(void)changeUser:(AduroUser*)user and:(LeeUserStatusBlock) completionHander;

/**
 获取所有用户列表，只能有管理员操作，其他用户没权操作这个命令，如列表为空或者刚出场的网关，那么第一个添加的为管理员

 @param completionHander 获取所有用户的反馈
 */
-(void)getAllUserand:(LeeGetAllUserBlock) completionHander;


@end
