//
//  AduroGateway.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/13.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeCommonObject.h"
typedef enum : NSUInteger {
    NetChannelTypeDisconnect = 0x00,/*连接中断*/
    NetChannelTypeLANUDP = 0x01,/*局域网UDP*/
    NetChannelTypeRemoteTCP = 0x02,/*远程TCP*/
    NetChannelTypeLANTCP = 0x03 /*局域网TCP*/
} NetChannelType;

@interface AduroGateway : LeeCommonObject

@property (nonatomic,copy) NSString *gatewayID;//网关编号
@property (nonatomic,copy) NSString *gatewayName;//网关名称
@property (nonatomic,copy) NSString *gatewaySoftwareVersion;//软件版本
@property (nonatomic,copy) NSString *gatewayHardwareVersion;//硬件版本
@property (nonatomic,copy) NSString *gatewaymanufacturer;//厂商
@property (nonatomic,copy) NSString *gatewaycoordinator;///协调器
@property (nonatomic,copy) NSString *gatewayMACAddress;//网关mac地址
@property (nonatomic,copy) NSString *gatewayIPv4Address;//IP地址
@property (nonatomic,strong) NSDate *gatewayDatetime;//时间
@property (nonatomic,assign) Byte   *gatewayTimeZone;//时区
@property (nonatomic,copy) NSString *gatewayServerDomain;//服务器域名 默认为
@property (nonatomic,copy) NSString *gatewaySecurityKey;//安全Key,通过扫描网关背部的二维码获取
@property (nonatomic,copy) NSString *gatewayGatewayType;//网关类型
@property (nonatomic,assign) Byte    gatewayToAppNetChannelType;//网关到APP的网络通道类型
@property (nonatomic,copy) NSString *gatewayOwner;//网关所有者

@end
