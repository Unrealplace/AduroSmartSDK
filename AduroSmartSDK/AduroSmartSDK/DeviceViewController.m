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
//#import "AduroDevice.h"

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
@property(nonatomic,strong)AduroGateway * gateWay;
@property(nonatomic,strong)UITextField  * TF1;
@property(nonatomic,strong)UITextField  * TF2;


@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    self.title  = @"decice";
    self.udpBtn = [UIButton new];
    self.udpBtn.frame = CGRectMake(50, 100, 180 , 80);
    [self.udpBtn setTitle:@"udp send commond" forState:UIControlStateNormal];
    [self.udpBtn addTarget:self action:@selector(udpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.udpBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.udpBtn];
    
    self.lampLabel  = [UILabel new];
    self.lampLabel.frame = CGRectMake(90, 200, 90, 30);
    self.lampLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.lampLabel];
    
    self.backCommondLabel  = [UILabel new];
    self.backCommondLabel.frame = CGRectMake(200, 200, 120, 30);
    self.backCommondLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.backCommondLabel];
    
    self.lampLabel.font = [UIFont systemFontOfSize:9];
    self.backCommondLabel.font = [UIFont systemFontOfSize:9];

    self.sendLabel  = [UILabel new];
    self.sendLabel.frame = CGRectMake(50, 200, 40, 30);
    self.sendLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.sendLabel];
    
    self.receiveLable  = [UILabel new];
    self.receiveLable.frame = CGRectMake(300, 200, 60, 30);
    self.receiveLable.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.receiveLable];
    
    self.sendLabel.text = @"send";
    self.receiveLable.text = @"revice";
    
    self.TF1 = [UITextField new];
    self.TF2 = [UITextField new];
    [self.view addSubview:_TF1];
    [self.view addSubview:_TF2];
    self.TF1.frame = CGRectMake(50, 240, 200, 30);
    self.TF2.frame = CGRectMake(50, 275, 200, 30);
    self.TF1.backgroundColor = [UIColor whiteColor];
    self.TF2.backgroundColor = [UIColor whiteColor];
    
    self.gatewayBtn = [UIButton new];
    self.gatewayBtn.frame = CGRectMake(50, 420, 160 , 80);
    [self.gatewayBtn setTitle:@"gateway find" forState:UIControlStateNormal];
    [self.gatewayBtn addTarget:self action:@selector(gatewayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.gatewayBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.gatewayBtn];
    

    self.gateLabel  = [UILabel new];
    self.gateLabel.frame = CGRectMake(50, 530, 200, 30);
    self.gateLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.gateLabel];
    self.gateLabel.font = [UIFont systemFontOfSize:9];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired = 1;
    [self.gateLabel addGestureRecognizer:tap];
    self.gateLabel.userInteractionEnabled = YES;
    
    
    
}

-(void)udpBtnClick{

//    NSString * dataStr = [NSString stringWithFormat:@"good %d",arc4random()];
//
//    self.lampLabel.text =dataStr;
//    [[DeviceManager sharedManager] findNewDevices:^(AduroDevice *device) {
//        NSLog(@"%@",[NSThread currentThread]);
//
//        dispatch_async(dispatch_get_main_queue(), ^{
////            self.backCommondLabel.text = device.dataStr;
//        });
//        
//    }];
    

    
    [[GatewayManager sharedManager] getGatewayConfigue:@"0011223344556677" andCompletionHandler:^(AduroSmartReturnCode code) {
        
    }];
    
    
}



-(void)mqttBtnClick{

    [[DeviceManager sharedManager] getAllDevices:^(AduroDevice *device) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.mqttLabel.text = device.data;
            
        });
    }];
}
-(void)gatewayBtnClick{

    [[GatewayManager sharedManager] searchGateways:^(NSArray *gateways) {
        
        if (gateways.count >0) {
            dispatch_async(dispatch_get_main_queue(), ^{

                self.gateLabel.text = [NSString stringWithFormat:@"%@ %@",[gateways[0] gatewayName],[gateways[0] gatewayIPv4Address]];
                self.gateWay = gateways[0];
            });
        }
    }];
}
-(void)tapClick:(UITapGestureRecognizer*)tap{

    [[GatewayManager sharedManager] connectGateway:self.gateWay andReturnCode:^(AduroSmartReturnCode code) {
        
        DLog(@"link:::%ld",code);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}



@end
