//
//  AduroUser.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/25.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface AduroUser : LeeCommonObject
@property(nonatomic,copy)NSString * userName;//用户名
@property(nonatomic,assign)Byte  userID;//用户编码
@property(nonatomic,copy)NSString * userIP;//用户ip
@end
