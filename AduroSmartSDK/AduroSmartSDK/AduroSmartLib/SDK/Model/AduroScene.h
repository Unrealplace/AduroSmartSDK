//
//  AduroScene.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/24.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface AduroScene : LeeCommonObject

@property(nonatomic,assign)UInt16 sceneID;//场景ID
@property(nonatomic,copy)NSString * SceneName;//场景名称
@property(nonatomic,assign)AduroSceneType sceneType;//场景类型
@property(nonatomic,assign)UInt16 groupID;//属于那个房间
@property(nonatomic,assign)Byte deviceCount;//设备数量
@property(nonatomic,strong)NSMutableArray * sceneDeviceIDArr;//场景中的设备序号集合

@end
