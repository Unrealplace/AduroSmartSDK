//
//  SceneManager.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
@class AduroScene;
typedef void (^LeeGetSceneBlock)(AduroScene * scene);
@interface SceneManager : LeeCommonObject


+(SceneManager*)sharedManager;

/**
  添加一个场景

 @param scene 要添加的场景
 @param completionHander 添加结果反馈
 */
-(void)addAScene:(AduroScene*)scene and:(LeeSceneStatusBlock)completionHander;

/**
 删除一个场景

 @param scene 要删除的场景
 @param completionHander 删除结果反馈
 */
-(void)deleteScene:(AduroScene*)scene and:(LeeSceneStatusBlock)completionHander;

/**
 控制一个场景

 @param scene 要控制的场景
 @param completionHander 控制结果反馈
 */
-(void)controlScene:(AduroScene*)scene and:(LeeSceneStatusBlock)completionHander;

/**
 修个一个场景

 @param scene 要修改的场景
 @param completionHander 修个结果反馈
 */
-(void)changeScene:(AduroScene*)scene and:(LeeSceneStatusBlock)completionHander;

/**
 获取场景列表

 @param completionHander 获取场景反馈结果
 */
-(void)getSceneListand:(LeeGetSceneBlock)completionHander;

/**
 获取一个场景

 @param scene 要获取的场景
 @param completionHander 获取结果反馈
 */
-(void)getScene:(AduroScene*)scene and:(LeeSceneStatusBlock)completionHander;


@end
