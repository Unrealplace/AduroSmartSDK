//
//  GatewayManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/13.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
@class AduroGateway;
@interface GatewayManager : LeeCommonObject

+ (GatewayManager *)sharedManager;


-(AduroGateway*)getCurrentGateway;

-(void)saveCurrentGateway:(AduroGateway*)gateway;

/**
 搜索网关
 @param gateways 搜索结果回调
 */
-(void)searchGateways:(LeeGatewaysInLanBlock)gateways;

/**
 获取网关配置信息

 @param gatewayNum 网关编码
 @param completionHandler 成功的反馈
 */
-(void)getGatewayConfigue:(NSString*)gatewayNum andCompletionHandler:(LeeGatewayStatusBlock)completionHandler;


/**
 连接网关
 @param gateway 网关
 @param completionHandler 连接网关回调
 */
-(void)connectGateway:(AduroGateway*)gateway andReturnCode:(LeeGatewayStatusBlock) completionHandler;

/**
 更新网关
 @param completionHandler 更新回调
 */
-(void)upgradeGatewayCompletionHandler:(LeeGatewayStatusBlock)completionHandler;

/**
 改变网关名称
 @param gatewayName 名称
 @param completionHandler 完成回调
 */
-(void)changeGatewayName:(NSString*)gatewayName andCompletionHandler:(LeeGatewayStatusBlock)completionHandler;

/**
 重置网关
 @param password 密码
 @param completionHandler 重置完成回调
 */
-(void)resetGatewayWithPwd:(NSString *)password andCompletionHandler:(LeeGatewayStatusBlock)completionHandler;


/**
 设置网关时间

 @param completionHandler 完成回调
 */
-(void)setGatewayTimeandCompletionHandler:(LeeGatewayStatusBlock)completionHandler;

/**
 设置网关远端服务器域名

 @param domain 域名
 @param completionHandler 设置完成回调
 */
-(void)setGatewayServer:(NSString*)domain andCompletionHandler:(LeeGatewayStatusBlock)completionHandler;



@end
