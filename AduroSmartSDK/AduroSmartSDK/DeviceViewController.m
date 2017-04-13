//
//  DeviceViewController.m
//  LeeTestAduro
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "DeviceViewController.h"
#import "DeviceManager.h"

@interface DeviceViewController ()

@property(nonatomic,strong)UIButton * udpBtn;
@property(nonatomic,strong)UILabel  * lampLabel;
@property(nonatomic,strong)UIButton * mqttBtn;
@property(nonatomic,strong)UILabel  * mqttLabel;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    self.title  = @"decice";
    self.udpBtn = [UIButton new];
    self.udpBtn.frame = CGRectMake(100, 100, 100 , 100);
    [self.udpBtn setTitle:@"udp find" forState:UIControlStateNormal];
    [self.udpBtn addTarget:self action:@selector(udpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.udpBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.udpBtn];
    
    self.lampLabel  = [UILabel new];
    self.lampLabel.frame = CGRectMake(100, 220, 200, 30);
    self.lampLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.lampLabel];
    
    
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
    
    
}

-(void)udpBtnClick{

    [[DeviceManager sharedManager] findNewDevices:^(AduroDevice *device) {
        NSLog(@"%@",[NSThread currentThread]);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.lampLabel.text = device.data;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}




@end
