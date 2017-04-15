//
//  DeviceManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "DeviceManager.h"
#import "LeeUDPClientManager.h"
#import "LeeMQTTManager.h"

@interface DeviceManager(){
    
    GetDevicesBlock _udpDevices;
    GetDevicesBlock _mqttDevices;
}
@end
@implementation DeviceManager

+(DeviceManager*)sharedManager{

    static DeviceManager * device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[DeviceManager alloc] init];
    });
    return device;
}
-(void)findNewDevices:(GetDevicesBlock)devices{
    _udpDevices = devices;
    [self sendData:nil];
    

}
-(void)getAllDevices:(GetDevicesBlock)devices{
    _mqttDevices = devices;
    [self sendData:nil];

}



-(void)sendData:(NSData*)data{

    if (IsRemoteConnect) {
        NSString * dataStr = [NSString stringWithFormat:@"hello mqtt %d",arc4random()];
        [[LeeMQTTManager sharedManager] mqttSendCommandData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] andReceiveDataBlock:^(id data) {
            
            AduroDevice *dev = [AduroDevice new];
            dev.data  = [[NSString alloc] initWithData:data[@"data"] encoding:NSUTF8StringEncoding];
            _mqttDevices(dev);
        } andErrorBlock:^(NSError *error) {
            
        }];
    }else{
    
        NSString * dataStr = [NSString stringWithFormat:@"good %d",arc4random()];
        [[LeeUDPClientManager sharedManager] sendData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] andReceiveData:^(NSData *data) {
            
            if ([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] hasPrefix:@"oliver"])   {
                AduroDevice * dev = [[AduroDevice alloc] init];
                dev.data =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                _udpDevices(dev);
            }
            
        } andError:^(NSError *error) {
            
        }];
    }
//    IsRemoteConnect = !IsRemoteConnect;
    
}
@end
