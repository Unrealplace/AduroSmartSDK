//
//  AduroDataTool.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/19.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "AduroDataTool.h"
#import "NSData+CRC.h"

@implementation AduroDataTool

+(NSData*)analysisLocalData:(NSMutableData *)data{
    
    if (!data) return nil;
    NSData * tranlateData = [data subdataWithRange:NSMakeRange(1, data.length -2)].mutableCopy;
    tranlateData          = [NSData UnTranlateData:tranlateData];
    NSData *DevData       = [tranlateData subdataWithRange:NSMakeRange(1, tranlateData.length-1)];
    return DevData;
}
+(NSData*)analysisGateData:(NSData*)data{

    if (!data) return nil;
    NSData * tranlateData = [data subdataWithRange:NSMakeRange(1, data.length -2)].mutableCopy;
    tranlateData = [NSData UnTranlateData:tranlateData];
    int head = Lee_PACKAGE_HEAD;
    int tail = Lee_PACKAGE_TAIL;
    [tranlateData.mutableCopy  appendData:[NSData dataWithBytes:&tail length:1]];
    NSMutableData * lastData = [NSMutableData dataWithData:[NSData dataWithBytes:&head length:1]];
    [tranlateData.mutableCopy appendData:lastData];
    return tranlateData;
}

+(NSData*)generateSendDataWithUserNumData:(NSString*)UserNum andCommnadData:(UInt16)commnad  andDeviceData:(NSData*)deviceData{
    //最后要发送的命令
    NSMutableData * sendCommondData = [NSMutableData data];
    //crc 校验的数据是除了包头包尾的数据拼接在一起
    NSMutableData * crcData         = [NSMutableData data];
    //方向一个字节
    NSData * dirdectionData = [Lee_DIRECTION dataUsingEncoding:NSUTF8StringEncoding];
    //用户编码8个字节
    NSData * userNumData    = [NSData hexStringToData:UserNum];
    //命令集2个字节
    NSData * commnadData    = [NSData get2BDataFromInt:commnad];
    //数据内容根据数据内容要进行转义
    NSData * tranlateData   ;
    //数据长度2个字节
    int      dataLen        ;
    NSData * lenData        ;
    
    if (deviceData == nil) {
        dataLen         = 0;
        lenData         = [NSData get2BDataFromInt:dataLen];
    }else{
         tranlateData   = [NSData TranlateData:deviceData];
         dataLen        = (int)tranlateData.length;
         lenData        = [NSData get2BDataFromInt:dataLen];
    }
    //////////////拼接crc////////////////
    [crcData appendData:dirdectionData];
    [crcData appendData:userNumData];
    [crcData appendData:commnadData];
    [crcData appendData:lenData];
    [crcData appendData:tranlateData];
    ///////////////////////////////////
    //CRC校验值2个字节
    int      crcLen     =   [NSData crc16:crcData];
    NSData * lenCrcData =   [NSData get2BDataFromInt:crcLen];
    
    //最后的转义数据
    [crcData appendData:lenCrcData];
    NSData * lastTranlateData = [NSData TranlateData:crcData];
    //包头，包尾 0x7e 0x7f
    NSData * headData   =   [NSData get1BDataFromInt:Lee_PACKAGE_HEAD];
    NSData * tailData   =   [NSData get1BDataFromInt:Lee_PACKAGE_TAIL];
    //合成数据/////////////////////////////
    [sendCommondData appendData:headData];//包头
//    [sendCommondData appendData:crcData];
//    [sendCommondData appendData:lenCrcData];
    [sendCommondData appendData:lastTranlateData];
    [sendCommondData appendData:tailData];//包尾
    
    DLog(@"发送的指令::%@",sendCommondData);
    return sendCommondData;
    
}

//1.获取网关配置信息 数据内容为空 包长 0x00
//2.获取用户列表    数据内容为空 包长 0x00
+(NSData*)generateDeviceData:(NSData *)deviceData{

    return nil;
}


@end
