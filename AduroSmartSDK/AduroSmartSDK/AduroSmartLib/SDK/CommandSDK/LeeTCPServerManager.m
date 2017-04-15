//
//  LeeTCPServerManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/15.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeTCPServerManager.h"

@interface LeeTCPServerManager()<GCDAsyncSocketDelegate>{

    AduroGCDAsyncSocket * _serverSocket;
    AduroGCDAsyncSocket * _newSocket;
}
@end
@implementation LeeTCPServerManager
-(void)startServerOnPort:(uint16_t)port{
    NSError * error = nil;
    _serverSocket = [[AduroGCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create(0, 0)];
    BOOL result = [_serverSocket acceptOnPort:port error:&error];
    if (result) {
        DLog(@"开启服务器");
    }else{
        DLog(@"开启服务出错:%@",error);
    }
    
}
#pragma mark TCP对象的代理方法

-(void)socket:(AduroGCDAsyncSocket *)sock didAcceptNewSocket:(AduroGCDAsyncSocket *)newSocket{
    DLog(@"接收到新的连接");
    _newSocket = newSocket;
    [_newSocket readDataWithTimeout:-1 tag:0];
}

-(void)socket:(AduroGCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    DLog(@"%ld,接收到%@发来的数据%@",tag,[sock connectedAddress],[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [_newSocket readDataWithTimeout:-1 tag:0];
    [_newSocket writeData:data withTimeout:-1 tag:0];
}

-(void)socketDidDisconnect:(AduroGCDAsyncSocket *)sock withError:(NSError *)err{
    DLog(@"%@",err);
}

-(void)socket:(AduroGCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [_newSocket readDataToData:[AduroGCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}
@end
