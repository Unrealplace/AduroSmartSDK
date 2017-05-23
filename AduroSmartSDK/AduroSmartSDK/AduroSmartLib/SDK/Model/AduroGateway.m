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
