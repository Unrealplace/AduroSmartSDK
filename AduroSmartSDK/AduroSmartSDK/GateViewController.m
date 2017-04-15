//
//  GateViewController.m
//  LeeTestAduro
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "GateViewController.h"
#import "LeeTCPClientManager.h"

@interface GateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * gateWayTableView;
@property(nonatomic,strong)NSMutableArray * gateWayArr;
@property(nonatomic,strong)UIButton * tcpClientBtn;
@property(nonatomic,strong)UILabel  *sendLable;
@property(nonatomic,strong)UILabel  *revLabel;
@property(nonatomic,strong)LeeTCPClientManager * tcpManager;

@end

@implementation GateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    self.title   = @"gateway";
//    [self.view addSubview:self.gateWayTableView];
    
    self.tcpClientBtn = [UIButton new];
    self.sendLable = [UILabel new];
    self.revLabel = [UILabel new];
    [self.view addSubview:self.tcpClientBtn];
    [self.view addSubview:self.sendLable];
    [self.view addSubview:self.revLabel];
    
    self.tcpClientBtn.frame = CGRectMake(100, 100, 100, 100);
    self.sendLable.frame = CGRectMake(100, 220, 200, 30);
    self.revLabel.frame = CGRectMake(100, 270, 200, 30);
    
    self.tcpClientBtn.backgroundColor = [UIColor redColor];
    self.sendLable.backgroundColor = [UIColor greenColor];
    self.revLabel.backgroundColor = [UIColor greenColor];
    
    [self.tcpClientBtn addTarget:self action:@selector(tcpClientBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

    self.tcpManager = [LeeTCPClientManager sharedManager];
    
    [self.tcpManager startTCPClientWithHost:@"192.168.1.100" andPort:9600];
    
    
}

-(void)tcpClientBtnClick{
    __weak typeof(self) weakSelf = self;

    NSString * data = [NSString stringWithFormat:@"hello server %d",arc4random()];
    
    [self.tcpManager sendData:[data dataUsingEncoding:NSUTF8StringEncoding] WithReciveDataBlock:^(id data) {
        DLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.revLabel.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
        });
        
    } andError:^(NSError *error) {
        DLog(@"%@",error);
        
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    
    
}


-(UITableView*)gateWayTableView{

    if (!_gateWayTableView) {
        _gateWayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _gateWayTableView.dataSource = self;
        _gateWayTableView.delegate   = self;
    }
    return _gateWayTableView;
}
#pragma mark tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellid = @"id";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}

@end
