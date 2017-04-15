//
//  LeeTCPClientManager.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/15.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "LeeTCPClientManager.h"

@interface LeeTCPClientManager()<GCDAsyncSocketDelegate>{

    LeeGetDataBlock _DataBlock;
    LeeGetErrorBlock _ErrorBlock;
    
    
}
@property(nonatomic,strong)AduroGCDAsyncSocket * tcpClient;
@property(nonatomic,assign)NSInteger  pushCount;
@property(nonatomic,strong)NSTimer   * connectTimer;
@property(nonatomic,assign)NSInteger  reconnectCount;
@property(nonatomic,copy)NSString * host;
@property(nonatomic,assign)uint16_t port;



@end
@implementation LeeTCPClientManager

+(LeeTCPClientManager*)sharedManager{
    
    static LeeTCPClientManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LeeTCPClientManager alloc] init];
    });
    return manager;
}

-(instancetype)init{

    if (self = [super init]) {
        self.host = nil;
        self.port = 0;
        self.tcpConnect = NO;
        [Lee_Notification addObserver:self selector:@selector(tcpEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [Lee_Notification addObserver:self selector:@selector(tcpEnterForGround) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}

-(void)tcpEnterBackGround{
    [self cutOffSocket];
}
-(void)tcpEnterForGround{

    [self reconnectServer];
    
}

-(BOOL)startTCPClientWithHost:(NSString *)host andPort:(uint16_t)port{

    if ((host.length != 0) && (port>10)) {
        NSError * error = nil;
        _pushCount = 0;
        _reconnectCount = 0;
        _host = host;
        _port = port;
        _tcpClient.delegate = nil;
        _tcpClient=nil;
        _tcpClient = [[AduroGCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create(0, 0)];
        self.commentResult = [_tcpClient connectToHost:host onPort:port error:&error];
        if (self.commentResult) {
            self.tcpConnect = YES;
        }else{
            DLog(@"连接服务器出错%@",error);
        }
        return self.commentResult;
    }else{
    
        return NO;
    }
   
    
}
void dispatch_after( dispatch_time_t when, dispatch_queue_t queue, dispatch_block_t block);

-(void)sendHeartBeat{

    
}
-(void)reconnectServer{
    
    self.pushCount = 0;
    self.reconnectCount = 0;
   __block NSError * error = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tcpClient connectToHost:self.host onPort:self.port error:&error];
        if (error) {
            DLog(@"连接出错%@",error);
        }
    });
    if ((self.host.length>0) &&(self.port>10)) {
        DLog(@"自动重连中...ip::%@ and port::%hu",self.host,self.port);
   
    }

   
}
-(void)cutOffSocket{
    
    self.pushCount = 0;
    self.reconnectCount = 0;
    [self.connectTimer invalidate];
    self.connectTimer = nil;
    [self.tcpClient disconnect];
    
}

-(void)sendData:(NSData *)commandData WithReciveDataBlock:(LeeGetDataBlock)tcpGetDataBlock andError:(LeeGetErrorBlock)tcpGetErrorBlokck{

    _ErrorBlock = tcpGetErrorBlokck;
    _DataBlock  = tcpGetDataBlock;
    
    [_tcpClient writeData:commandData withTimeout:-1 tag:100];
    [_tcpClient readDataWithTimeout:-1 tag:200];
    
    
}

#pragma mark TCP对象的代理方法 
-(void)socket:(AduroGCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{

    _tcpConnect = [_tcpClient isConnected];
    DLog(@"已经连接到%@",host);
    [sock readDataWithTimeout:-1 tag:200];
}
-(void)socket:(AduroGCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    DLog(@"接收到Server数据%@地址%@",data,[sock connectedHost]);
    _DataBlock(data);
    [sock readDataWithTimeout:-1 tag:200];
    self.pushCount++;
}

-(void)socket:(AduroGCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:200];
}

-(void)socketDidDisconnect:(AduroGCDAsyncSocket *)sock withError:(NSError *)err{
    DLog(@"网络连接断开%@",err);
    self.pushCount = 0;
    _tcpConnect = [_tcpClient isConnected];
    if (_ErrorBlock) {
    _ErrorBlock(err);
    }
    if ([[Lee_Userdefault valueForKey:@"Status"] isEqualToString:@"foreground"]) {
        self.reconnectCount++;
        [self.connectTimer invalidate];
        self.connectTimer = nil;
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
        self.connectTimer = timer;
        [self.connectTimer fire];
    }
     
}

@end
