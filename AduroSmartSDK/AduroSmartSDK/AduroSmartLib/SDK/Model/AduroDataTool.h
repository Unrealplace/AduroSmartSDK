//
//  AduroDataTool.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/19.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"

@interface AduroDataTool : LeeCommonObject

+(NSData*)getTheData:(NSData*)data;


/**
 生成发送命令的数据

 @param UserNum 用户编码
 @param commnad 命令集
 @param deviceData 数据内容
 @return 最终命令
 */
+(NSData*)generateSendDataWithUserNumData:(NSString*)UserNum andCommnadData:(UInt16)commnad  andDeviceData:(NSData*)deviceData;

+(NSData*)generateDeviceData:(NSData*)deviceData;


@end
