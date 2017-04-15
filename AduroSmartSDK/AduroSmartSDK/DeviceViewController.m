//
//  DeviceViewController.m
//  LeeTestAduro
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "DeviceViewController.h"
#import "DeviceManager.h"
#import "GatewayManager.h"
#import "AduroGateway.h"

@interface DeviceViewController ()

@property(nonatomic,strong)UIButton * udpBtn;
@property(nonatomic,strong)UILabel  * lampLabel;
@property(nonatomic,strong)UIButton * mqttBtn;
@property(nonatomic,strong)UILabel  * mqttLabel;
@property(nonatomic,strong)UIButton * gatewayBtn;
@property(nonatomic,strong)UILabel  * gateLabel;
@property(nonatomic,strong)UILabel  * backCommondLabel;
@property(nonatomic,strong)UILabel  * sendLabel;
@property(nonatomic,strong)UILabel  * receiveLable;


@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    self.title  = @"decice";
    self.udpBtn = [UIButton new];
    self.udpBtn.frame = CGRectMake(100, 100, 180 , 100);
    [self.udpBtn setTitle:@"udp device commond" forState:UIControlStateNormal];
    [self.udpBtn addTarget:self action:@selector(udpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.udpBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.udpBtn];
    
    self.lampLabel  = [UILabel new];
    self.lampLabel.frame = CGRectMake(100, 220, 90, 30);
    self.lampLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.lampLabel];
    
    self.backCommondLabel  = [UILabel new];
    self.backCommondLabel.frame = CGRectMake(200, 220, 100, 30);
    self.backCommondLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.backCommondLabel];
    
    self.lampLabel.font = [UIFont systemFontOfSize:9];
    self.backCommondLabel.font = [UIFont systemFontOfSize:9];

    self.sendLabel  = [UILabel new];
    self.sendLabel.frame = CGRectMake(60, 220, 40, 30);
    self.sendLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.sendLabel];
    
    self.receiveLable  = [UILabel new];
    self.receiveLable.frame = CGRectMake(300, 220, 40, 30);
    self.receiveLable.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.receiveLable];
    
    self.sendLabel.text = @"send";
    self.receiveLable.text = @"revice";
    
    
    self.mqttBtn = [UIButton new];
    self.mqttBtn.frame = CGRectMake(100, 260, 100 , 100);
    [self.mqttBtn setTitle:@"mqtt find" forState:UIControlStateNormal];
    [self.mqttBtn addTarget:self action:@selector(mqttBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.mqttBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.mqttBtn];
    
    self.mqttLabel  = [UILabel new];
    self.mqttLabel.frame = CGRectMake(100, 380, 200, 30);
    self.mqttLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.mqttLabel];
    

    self.gatewayBtn = [UIButton new];
    self.gatewayBtn.frame = CGRectMake(100, 420, 160 , 100);
    [self.gatewayBtn setTitle:@"gateway find" forState:UIControlStateNormal];
    [self.gatewayBtn addTarget:self action:@selector(gatewayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.gatewayBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.gatewayBtn];
    
    
    
    self.gateLabel  = [UILabel new];
    self.gateLabel.frame = CGRectMake(100, 530, 200, 30);
    self.gateLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.gateLabel];
    self.gateLabel.font = [UIFont systemFontOfSize:9];
    
    
}

-(void)udpBtnClick{

    NSString * dataStr = [NSString stringWithFormat:@"good %d",arc4random()];

    self.lampLabel.text =dataStr;
    [[DeviceManager sharedManager] findNewDevices:^(AduroDevice *device) {
        NSLog(@"%@",[NSThread currentThread]);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.backCommondLabel.text = device.data;
        });
        
    }];
    
}
-(void)mqttBtnClick{

    [[DeviceManager sharedManager] getAllDevices:^(AduroDevice *device) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mqttLabel.text = device.data;
        });
    }];
}
-(void)gatewayBtnClick{

    [[GatewayManager sharedManager] searchGateways:^(NSArray *gateways) {
        
        if (gateways.count >0) {
            dispatch_async(dispatch_get_main_queue(), ^{

                self.gateLabel.text = [NSString stringWithFormat:@"%@:%@",[gateways[0] gatewayName],[gateways[0] gatewayIPv4Address]];
            });
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}




@end
