//
//  DeviceManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "DeviceManager.h"
#import "AduroGCDAsyncSocket.h"
#import "AduroGCDAsyncUdpSocket.h"
#import "LeeUDPClientManager.h"
#import "LeeMQTTClientManager.h"
#import "AduroDevice.h"

@interface DeviceManager(){
    
    LeeGetDevicesBlock _udpDevices;
    LeeGetDevicesBlock _mqttDevices;
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
-(instancetype)init{

    if (self = [super init]) {
        
        [Lee_Notification addObserver:self selector:@selector(localOrRemote) name:Lee_Local_or_Remote object:nil];
        [Lee_Notification addObserver:self selector:@selector(findDevice:) name:Lee_FIND_DEVICE object:nil];
        
    }
    return self;
}
-(void)localOrRemote{

    NETLog(@"%ld",(long)GlobalConnectStatus);

}
-(void)findDevice:(NSNotification*)noti{

    
}
-(void)findNewDevices:(LeeGetDevicesBlock)devices{
    _udpDevices = devices;
    [self sendData:nil];
    

}
-(void)getAllDevices:(LeeGetDevicesBlock)devices{
    _mqttDevices = devices;
    [self sendData:nil];

}



-(void)sendData:(NSData*)data{

    switch (GlobalConnectStatus) {
            
        case NetTypeRemote:{
            MLog(@"远程在发送数据");
            NSString * dataStr = [NSString stringWithFormat:@"hello mqtt %d",arc4random()];
            [[LeeMQTTClientManager sharedManager] mqttSendCommandData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] andReceiveDataBlock:^(id data) {
                
                AduroDevice *dev = [[AduroDevice alloc] init];
                dev.dataStr  = [[NSString alloc] initWithData:data[@"data"] encoding:NSUTF8StringEncoding];
                if (_mqttDevices) {
                    _mqttDevices(dev);
                }
            } andErrorBlock:^(NSError *error) {
                
            }];
        }
            break;
            
        case NetTypeLocal:{
            MLog(@"局域网在发送数据");
            NSString * dataStr = [NSString stringWithFormat:@"good %d",arc4random()];
            [[LeeUDPClientManager sharedManager] sendData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] andReceiveData:^(id data) {
                NSData * datastr = data[@"gateway"];
//                if ([[[NSString alloc] initWithData:datastr encoding:NSUTF8StringEncoding] hasPrefix:@"oliver"])   {
                    AduroDevice * dev = [[AduroDevice alloc] init];
                    dev.dataStr =[[NSString alloc] initWithData:datastr encoding:NSUTF8StringEncoding];
                    _udpDevices(dev);
//                }
                
            } andError:^(NSError *error) {
                
            }];
        }
            break;
        case NetTypeUnreachble:{
            MLog(@"网络不可用");
  
        }
            break;
            
        default:
            break;
    }

}
@end
