//
//  AduroGateway.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/13.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "AduroGateway.h"

@implementation AduroGateway

-(NSString *)description{
    return [[NSString alloc]initWithFormat:@"gatewayID = %@ ,gatewayName = %@,gatewaySoftwareVersion = %@ ,gatewayHardwareVersion = %@ ,gatewayIPv4Address = %@ ,gatewayDatetime = %@ ,gatewaySecurityKey = %@,gatewayMACAddress = %@ ",self.gatewayID,self.gatewayName,self.gatewaySoftwareVersion,self.gatewayHardwareVersion,self.gatewayIPv4Address,self.gatewayDatetime,self.gatewaySecurityKey,self.gatewayMACAddress];
}


//@property (nonatomic,copy) NSString *gatewayID;//网关编号
//@property (nonatomic,copy) NSString *gatewayName;//网关名称
//@property (nonatomic,copy) NSString *gatewaySoftwareVersion;//软件版本
//@property (nonatomic,copy) NSString *gatewayHardwareVersion;//硬件版本
//@property (nonatomic,copy) NSString *gatewaymanufacturer;//厂商
//@property (nonatomic,copy) NSString *gatewaycoordinator;///协调器
//@property (nonatomic,copy) NSString *gatewayMACAddress;//网关mac地址
//@property (nonatomic,copy) NSString *gatewayIPv4Address;//IP地址
//@property (nonatomic,strong) NSDate *gatewayDatetime;//时间
//@property (nonatomic,assign) Byte   *gatewayTimeZone;//时区
//@property (nonatomic,copy) NSString *gatewayServerDomain;//服务器域名 默认为
//@property (nonatomic,copy) NSString *gatewaySecurityKey;//安全Key,通过扫描网关背部的二维码获取
//@property (nonatomic,copy) NSString *gatewayGatewayType;//网关类型
//@property (nonatomic,assign) Byte    gatewayToAppNetChannelType;//网关到APP的网络通道类型
//@property (nonatomic,copy) NSString *gatewayOwner;//网关所有者

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    if (self.gatewaymanufacturer) {
        [encoder encodeObject:self.gatewaymanufacturer forKey:@"gatewaymanufacturer"];
    }
    if (self.gatewaycoordinator) {
        [encoder encodeObject:self.gatewaycoordinator forKey:@"gatewaycoordinator"];
    }
    if (self.gatewayMACAddress) {
        [encoder encodeObject:self.gatewayMACAddress forKey:@"gatewayMACAddress"];
    }
    
    if (self.gatewayName) {
        [encoder encodeObject:self.gatewayName forKey:@"gatewayName"];
    }
    if (self.gatewayID) {
        [encoder encodeObject:self.gatewayID forKey:@"gatewayID"];
    }
    if (self.gatewaySoftwareVersion) {
        [encoder encodeObject:self.gatewaySoftwareVersion forKey:@"gatewaySoftwareVersion"];
    }
    if (self.gatewayHardwareVersion) {
        [encoder encodeObject:self.gatewayHardwareVersion forKey:@"gatewayHardwareVersion"];
    }
    if (self.gatewayIPv4Address) {
        [encoder encodeObject:self.gatewayIPv4Address forKey:@"gatewayIPv4Address"];
    }
    if (self.gatewayDatetime) {
        [encoder encodeObject:self.gatewayDatetime forKey:@"gatewayDatetime"];
    }
    if (self.gatewaySecurityKey) {
        [encoder encodeObject:self.gatewaySecurityKey forKey:@"gatewaySecurityKey"];
    }
    if (self.gatewayGatewayType) {
        [encoder encodeObject:self.gatewayGatewayType forKey:@"gatewayGatewayType"];
    }
    if (self.gatewayServerDomain) {
        [encoder encodeObject:self.gatewayServerDomain forKey:@"gatewayServerDomain"];
    }
    if (self.gatewayToAppNetChannelType != 0) {
        [encoder encodeObject:@(self.gatewayToAppNetChannelType) forKey:@"gatewayToAppNetChannelType"];
    }
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.gatewaymanufacturer = [decoder decodeObjectForKey:@"gatewaymanufacturer"];
        self.gatewayMACAddress   = [decoder decodeObjectForKey:@"gatewayMACAddress"];
        self.gatewaycoordinator  = [decoder decodeObjectForKey:@"gatewaycoordinator"];
        self.gatewayID = [decoder decodeObjectForKey:@"gatewayID"];
        self.gatewayName = [decoder decodeObjectForKey:@"gatewayName"];
        self.gatewaySoftwareVersion = [decoder decodeObjectForKey:@"gatewaySoftwareVersion"];
        self.gatewayHardwareVersion = [decoder decodeObjectForKey:@"gatewayHardwareVersion"];
        self.gatewayIPv4Address = [decoder decodeObjectForKey:@"gatewayIPv4Address"];
        self.gatewayDatetime = [decoder decodeObjectForKey:@"gatewayDatetime"];
        self.gatewaySecurityKey = [decoder decodeObjectForKey:@"gatewaySecurityKey"];
        self.gatewayGatewayType = [decoder decodeObjectForKey:@"gatewayGatewayType"];
        self.gatewayServerDomain = [decoder decodeObjectForKey:@"gatewayServerDomain"];
        self.gatewayToAppNetChannelType = [[decoder decodeObjectForKey:@"gatewayToAppNetChannelType"] intValue];
    }
    return  self;
}

@end
