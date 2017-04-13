//
//  GateViewController.m
//  LeeTestAduro
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "GateViewController.h"


@interface GateViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * gateWayTableView;
@property(nonatomic,strong)NSMutableArray * gateWayArr;
@end

@implementation GateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    self.title   = @"gateway";
    [self.view addSubview:self.gateWayTableView];
    
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
