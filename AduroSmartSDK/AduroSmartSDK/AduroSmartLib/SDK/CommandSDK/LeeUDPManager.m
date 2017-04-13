//
//  LeeUDPManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeUDPManager.h"
#import "AduroGCDAsyncUdpSocket.h"
#import "AppEnum.h"
#define CLIENTPORT 8665
#define SERVERPORT 9600
@interface LeeUDPManager()<GCDAsyncUdpSocketDelegate>{
    
    AduroUDPReceiveDataBlock  _receiveDataBlock;
    AduroUDPReceiveErrorBlock _errorBlock;
    AduroUDPReceiveDataBlock  _startUDPDataBlock;
    AduroUDPReceiveErrorBlock _startUDPErrorBlock;
    
}
@property (nonatomic,strong)AduroGCDAsyncUdpSocket * UDPClient;

@end

@implementation LeeUDPManager

+(instancetype)sharedManager{
    
    static LeeUDPManager * client = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        client = [[LeeUDPManager alloc] init];
    });
    return client;
    
}
-(BOOL)startUDPClientWithFeedBackBlock:(AduroUDPReceiveDataBlock)receiveDataBlock andError:(AduroUDPReceiveErrorBlock)errorBlock{
    
    BOOL bindResult = NO;
    NSError * error;
    [self closeUDPClient];
    if (_UDPClient == nil) {
        _startUDPErrorBlock = errorBlock;
        _startUDPDataBlock  = receiveDataBlock;
        
        _UDPClient = [[AduroGCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("udpclient_queue", NULL)];
        bindResult =  [_UDPClient bindToPort:self.udpPort error:&error];
        if (error) {
            DLog(@"bind error:::%@",error);
        }
        [_UDPClient beginReceiving:nil];
    }else{
        
        return YES;
    }
    return bindResult;
}

-(void)sendData:(NSData*)commandData andReceiveData:(AduroUDPReceiveDataBlock)receiveDataBlock andError:(AduroUDPReceiveErrorBlock)errorBlock{
    
    @try {
        if (_receiveDataBlock==nil) {
            _receiveDataBlock = receiveDataBlock;
        }
        if (_errorBlock==nil) {
            _errorBlock       = errorBlock;
        }
        if (commandData.length == 0) {
            NSError * error = [NSError errorWithDomain:@"error command data" code:0 userInfo:@{@"commanddata":@"null"}];
            _errorBlock(error);
            return;
        }
        [_UDPClient sendData:commandData toHost:self.host port:self.udpPort withTimeout:20 tag:200];
        self.udpConnect = YES;
    } @catch (NSException *exception) {
        DLog(@"send data error:::%@",exception);
    } @finally {
        
    }
    
}
//关闭网络对象
-(void)closeUDPClient{
    [_UDPClient close];
    [_UDPClient close];
    _UDPClient.delegate = nil;
    _UDPClient = nil;
    self.udpConnect = NO;
}


#pragma mark udpsocket delegate;
- (void)udpSocket:(AduroGCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address{
    
    self.udpConnect = YES;
    
}


- (void)udpSocket:(AduroGCDAsyncUdpSocket *)sock didNotConnect:(NSError * _Nullable)error{
    
//    NSLog(@"not connect--->>>%@",error);
    if (_errorBlock) {
        _errorBlock(error);
    }
    if (_startUDPErrorBlock) {
        _startUDPErrorBlock(error);
    }
    self.udpConnect = YES;
    
}

- (void)udpSocket:(AduroGCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    
    if (tag == 200) {
//        NSLog(@"client发送数据");
    }
}

- (void)udpSocket:(AduroGCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error{
    if (tag == 200) {
        DLog(@"client发送失败-->%@",error);
        if (_errorBlock) {
            _errorBlock(error);
        }
        if (_startUDPErrorBlock) {
            _startUDPErrorBlock(error);
        }
    }
}


- (void)udpSocket:(AduroGCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
    
    DLog(@"IP地址:%@,Port:%u",
          [AduroGCDAsyncUdpSocket hostFromAddress:address],
          [AduroGCDAsyncUdpSocket portFromAddress:address]);
    self.host    = [AduroGCDAsyncUdpSocket hostFromAddress:address];
    self.udpPort = [AduroGCDAsyncUdpSocket portFromAddress:address];
    
    if (_receiveDataBlock) {
        _receiveDataBlock(data);
    }
    if (_startUDPDataBlock) {
        _startUDPDataBlock(data);
    }
    self.udpConnect = YES;
}

- (void)udpSocketDidClose:(AduroGCDAsyncUdpSocket *)sock withError:(NSError  * _Nullable)error{
    
    DLog(@"clientClose error--->>>%@",error);
    if (_errorBlock) {
        _errorBlock(error);
    }
    if (_startUDPErrorBlock) {
        _startUDPErrorBlock(error);
    }
    self.udpConnect = NO;
    
}

@end