//
//  NSData+CRC.m
//  AduroSmartFrameWork
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "NSData+CRC.h"

@implementation NSData (CRC)
+(unsigned short)crc16:(NSData *)data
{
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    uint16_t length = (uint16_t)[data length];
    return (unsigned short)gen_crc16(bytes, length);
}


#define CRC16 0x8005

uint16_t gen_crc16(const uint8_t *data, uint16_t size)
{
    uint16_t out = 0;
    int bits_read = 0, bit_flag;
    
    if(data == NULL)
        return 0;
    
    while(size > 0)
    {
        bit_flag = out >> 15;
        
        out <<= 1;
        out |= (*data >> bits_read) & 1;
        
        bits_read++;
        if(bits_read > 7)
        {
            bits_read = 0;
            data++;
            size--;
        }
        
        if(bit_flag)
            out ^= CRC16;
        
    }
    
    int i;
    for (i = 0; i < 16; ++i) {
        bit_flag = out >> 15;
        out <<= 1;
        if(bit_flag)
            out ^= CRC16;
    }
    
    uint16_t crc = 0;
    i = 0x8000;
    int j = 0x0001;
    for (; i != 0; i >>=1, j <<= 1) {
        if (i & out) crc |= j;
    }
    
    return crc;
    
}

+(unsigned short)crc8:(NSData *)data
{
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    uint16_t length = (uint16_t)[data length];
    return (unsigned short)gen_crc8(bytes, length);
}

uint16_t gen_crc8(const uint8_t *data, uint16_t size)
{
    uint16_t out = 0;
    return f_crc8(out, data, size);
}


uint8_t f_crc8(uint8_t  crc_val,const uint8_t *buf,uint32_t len)
{
    uint32_t l=0;
    uint8_t i, crc;
    uint16_t init=0;
    
    init=crc_val*0x100;
    for(l=0;l<len;l++)
    {
        init^=(buf[l]*0x100);
        for(i=0;i<8;i++)
        {
            if(init&0x8000)
                init^=0x8380;
            init*=2;
        }
    }
    crc = init/0x100;
    return crc;
}


+(NSData*)TranlateData:(NSData *)data{
    
    Byte pout[data.length+[self NeedTranlate:data]];
    Byte *byte = (Byte*)[data bytes];
    UInt16 len = [NSData CMEscape:pout and:byte and:data.length];
    NSData * lastData = [[NSData alloc] initWithBytes:pout length:len];
    for (int i = 0; i < sizeof(pout); i++) {
        NSLog(@"%hhu",pout[i]);
    }
    return lastData;
}

+(NSData*)UnTranlateData:(NSData *)data{
    
    Byte pout[data.length - [self NeeUnTranlate:data]];
    Byte *byte = (Byte*)[data bytes];
    [NSData CMUnEscape:pout and:byte and:data.length];
    NSData * lastData = [[NSData alloc] initWithBytes:pout length:sizeof(pout)];
    
    for (int i = 0; i < sizeof(pout); i++) {
        NSLog(@"fff:%hhu",pout[i]);
    }
    return lastData;
}



/**
 需要进行转义的个数
 
 @return 个数
 */
+ (UInt16) NeedTranlate:(NSData *)data{
    Byte *bytes = (Byte*)[data bytes];
    UInt16 count = 0;
    for (int i = 0; i < data.length; i++) {
        if ((bytes[i]==0x7d) || (bytes[i]==0x7e) || (bytes[i]==0x7f)){
            count=count+1;
        }
    }
    return count;
}
+(UInt16) NeeUnTranlate:(NSData *)data{
    
    Byte *bytes = (Byte*)[data bytes];
    UInt16 count = 0;
    for (int i = 0; i < data.length; i++) {
        if (bytes[i]==0x7d ){
            count=count+1;
        }
    }
    return count;
}
/************************************************************************************** * FunctionName : CMEscape()
 * Description : 数据转义
 * EntryParameter : pOut - 转义后的数据; pIn - 需转义的数据; len - 数据长度
 * ReturnValue : 转义后的数据长度 **************************************************************************************/
+(UInt16) CMEscape:(UInt8 *)pOut and:(UInt8 *)pIn and:(UInt16) len
{
    UInt16 i;
    UInt16 tmpLen = 0;
    for (i=0; i<len; i++)
    {
        if ((i == 0) || (i == len-1)) {
            pOut[tmpLen++] = pIn[i];
        }
        else {
            // 把帧头和帧尾之家出现的 0x7D\0x7E\0x7F 转换成 0x5D\0x5E\0x5F，并在前面加上 0x7D
            if ((pIn[i]==0x7D) || (pIn[i]==0x7E) || (pIn[i]==0x7F))
            {
                pOut[tmpLen++] = 0x7D;
                pOut[tmpLen++] = pIn[i] - 0x20;
            } else {
                pOut[tmpLen++] = pIn[i];
            }
        }
    }
    return tmpLen;
}

/************************************************************************************** * FunctionName : CMUnEscape()
 * Description : 数据反转义
 * EntryParameter : pOut - 反转义后的数据; pIn - 需反转义的数据; len - 数据长度
 * ReturnValue : 转义后的数据长度 CMUnEscape  **************************************************************************************/
+(UInt16) CMUnEscape:(UInt8 *)pOut and:(UInt8 *)pIn and:(UInt16) len
{
    UInt16 i;
    UInt16 tmpLen = 0;
    for (i=0; i<len; i++)
    {
        // 去掉加上的 0x7D,加上 0x20,获取原始值
        pOut[tmpLen++] = ((pIn[i] == 0x7d) ? (pIn[++i] + 0x20) : pIn[i]);
    }
    return tmpLen;
}

+(NSData *) get2BDataFromInt:(int)len{
    //用2个字节接收
    Byte bytes[2];
    bytes[0] = (Byte)(len>>8);
    bytes[1] = (Byte)(len);
    NSData *data = [NSData dataWithBytes:bytes length:2];
    NSLog(@"%@",data);
    return data;
}
+(NSData*) get1BDataFromInt:(int)len{
    Byte  bytes[1];
    bytes[0] = (Byte)len;
    NSData * data = [NSData dataWithBytes:bytes length:1];
    return data;
}

//补充内容，因为没有三个字节转int的方法，这里补充一个通用方法
+(unsigned)parseIntFromData:(NSData *)data{
    
    NSString *dataDescription = [data description];
    NSString *dataAsString = [dataDescription substringWithRange:NSMakeRange(1, [dataDescription length]-2)];
    
    unsigned intData = 0;
    NSScanner *scanner = [NSScanner scannerWithString:dataAsString];
    [scanner scanHexInt:&intData];
    
    NSLog(@"ggg:::%d",intData);
    return intData;
}

//  十进制转二进制
+ (NSString *)toBinarySystemWithDecimalSystem:(int)num length:(int)length
{
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    NSString * prepare = @"";
    while (true){
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        if (divisor == 0)
        {
            break;
        }
    }
    //倒序输出
    NSString * result = @"";
    for (int i = length -1; i >= 0; i--){
        if (i <= prepare.length - 1) {
            result = [result stringByAppendingFormat:@"%@",
                      [prepare substringWithRange:NSMakeRange(i , 1)]];
        }else{
            result = [result stringByAppendingString:@"0"];
            
        }
    }
    return result;
}
//  二进制转十进制
+(NSString *)toDecimalWithBinary:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}
//将十进制转化为十六进制
+ (NSString *)ToHex:(int)intData{
    NSString *nLetterValue;
    NSString *str =@"";
    int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig =intData%16;
        intData=intData/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (intData == 0) {
            break;
        }
    }
    //不够一个字节凑0
    if(str.length == 1){
        return [NSString stringWithFormat:@"0%@",str];
    }else{
        return str;
    }
}
//普通字符串转换为十六进制的。

- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if ([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}



//十六进制转换为普通字符串的。

- (NSString *)stringFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"字符串%@",unicodeString);
    return unicodeString;
}
//数字转十六进制字符串

- (NSString *)stringWithHexNumber:(NSUInteger)hexNumber{
    char hexChar[6];
    sprintf(hexChar, "%x", (int)hexNumber);
    NSString *hexString = [NSString stringWithCString:hexChar encoding:NSUTF8StringEncoding];
    return hexString;
}
//十六进制字符串转数字

- (NSInteger)numberWithHexString:(NSString *)hexString{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}
//将NSData转换成十六进制的字符串

- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
//将十六进制字符串转换成NSData
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0){
        range = NSMakeRange(0, 2);
    } else range = NSMakeRange(0, 1);
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        range.location += range.length;
        range.length = 2;
    }
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}
@end
