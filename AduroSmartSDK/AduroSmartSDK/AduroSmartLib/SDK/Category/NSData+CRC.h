//
//  NSData+CRC.h
//  AduroSmartFrameWork
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CRC)
+(unsigned short) crc8:(NSData *)data;
+ (UInt16) NeedTranlate:(NSData *)data;
+(UInt16) CMUnEscape:(UInt8 *)pOut and:(UInt8 *)pIn and:(UInt16) len;
+(UInt16) CMEscape:(UInt8 *)pOut and:(UInt8 *)pIn and:(UInt16) len;
+(UInt16) NeeUnTranlate:(NSData *)data;

/**
 转义

 @param data 要转的数据
 @return 转后的数据
 */
+(NSData*)TranlateData:(NSData*)data;

/**
 反转义

 @param data 要转的数据
 @return 反转义的数据
 */
+(NSData*)UnTranlateData:(NSData*)data;

/**
 CRC16 校验

 @param data 要校验的数据
 @return 返回校验和
 */
+(unsigned short) crc16:(NSData *)data;


/**
 10进制数转换成2字节数

 @param len 10进制数 可传递0xffff这样的指令
 */
+(NSData *)get2BDataFromInt:(int)len;

+(NSData*)get1BDataFromInt:(int)len;

+(NSData*)get8BDataFromString:(NSString*)String;

/**
 NSData 转int 型

 @param data data
 @return int 数据
 */
+(unsigned)parseIntFromData:(NSData *)data;

/**
 二进制转10进制

 @param binary 二进制字符串
 @return 10进制数据
 */
+(NSString *)toDecimalWithBinary:(NSString *)binary;

/**
 <#Description#>

 @param num <#num description#>
 @param length <#length description#>
 @return <#return value description#>
 */
+ (NSString *)toBinarySystemWithDecimalSystem:(int)num length:(int)length;

/**
 10 进制数转换成16进制字符串
 @param intData 10进制数
 @return 返回16进制字符串
 */
+ (NSString *)ToHex:(int)intData;

/**
 16进制字符串转换成NSdata

 @param hexString 16进制字符串
 @return NSdata
 */
+(NSData *)hexStringToData:(NSString *)hexString;
@end
