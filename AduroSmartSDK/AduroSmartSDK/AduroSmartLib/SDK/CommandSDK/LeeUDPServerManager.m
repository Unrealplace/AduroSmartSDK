//
//  LeeUDPServerManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/15.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeUDPServerManager.h"
#import "AduroGCDAsyncUdpSocket.h"
#define CLIENTPORT 8888

@interface LeeUDPServerManager()<GCDAsyncUdpSocketDelegate>{

    LeeGetDataBlock _serverDataBlock;
}

@property(nonatomic,strong)AduroGCDAsyncUdpSocket * udpServer;
@property (nonatomic,copy)NSString * clientHost;
@property (nonatomic,assign)uint16_t   clientPort;


@end
@implementation LeeUDPServerManager

-(void)startUDPServerWithPort:(uint16_t)port{

    dispatch_queue_t dQueue = dispatch_queue_create("Server queue", NULL);
    _udpServer = [[AduroGCDAsyncUdpSocket alloc] initWithDelegate:self
                                                       delegateQueue:dQueue];
    NSError *error;
    [_udpServer bindToPort:port error:&error];
    if (error) {
        NSLog(@"服务器绑定失败");
    }
    if (![_udpServer enableBroadcast:YES error:&error]) {
        NSLog(@"Error enableBroadcast (bind): %@", error);
        return;
    }
    if (![_udpServer joinMulticastGroup:@"224.0.0.1"  error:&error]) {
        NSLog(@"Error joinMulticastGroup (bind): %@", error);
        return;
    }
    [_udpServer beginReceiving:nil];
    
  
}
- (void)sendCommandAndRecieveData:(LeeGetDataBlock)udpServerGetDataBlock{
    
    _serverDataBlock = udpServerGetDataBlock;
    
    NSString * commandStr = [NSString stringWithFormat:@"oliver-%d",arc4random()];
    [_udpServer sendData:[commandStr dataUsingEncoding:NSUTF8StringEncoding] toHost:self.clientHost port:self.clientPort withTimeout:30 tag:60];
    
    
}
- (void)sendBroadCast{
    __block int timeout=15; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
            });
        }else{
            [self timerAction];
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}
-(void)timerAction{
    
    //在这里执行事件
//    NSData * data = [NSJSONSerialization dataWithJSONObject:nil options:NSJSONWritingPrettyPrinted error:nil];
    [_udpServer sendData:nil toHost:@"255.255.255.255" port:CLIENTPORT withTimeout:30 tag:10];
}

-(void)udpSocket:(AduroGCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    NSLog(@"send data");
    
}

-(void)udpSocket:(AduroGCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    
    NSLog(@"%@",error);
}
- (void)udpSocket:(AduroGCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    /**
     *  更新UI一定要到主线程去操作啊
     */
    dispatch_sync(dispatch_get_main_queue(), ^{
//        self.textView.text = msg;
    });
    NSLog(@"客户端ip地址-->%@,port--->%u,内容-->%@",
          [AduroGCDAsyncUdpSocket hostFromAddress:address],
          [AduroGCDAsyncUdpSocket portFromAddress:address],
          msg);
    self.clientHost = [AduroGCDAsyncUdpSocket hostFromAddress:address];
    self.clientPort = [AduroGCDAsyncUdpSocket portFromAddress:address];
    
    if (_serverDataBlock) {
        _serverDataBlock(data);
    }
    
}



@end
