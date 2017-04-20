//
//  AduroSmartSDK+AnalysisData.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/19.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "AduroSmartSDK+AnalysisData.h"
#import "NetTypeModel.h"
#import "AduroGateway.h"
#import "AduroDataTool.h"

@implementation AduroSmartSDK (AnalysisData)

-(void)AnalysisData:(id)data withNetModel:(NetTypeModel *)model{

    DLog(@"%@",data);
    
    NSData * gatedata =  data[@"gateway"];
    if (gatedata != nil) {
        NSString * gateStr = [[NSString alloc] initWithData:gatedata encoding:NSUTF8StringEncoding];
        if (![gateStr hasPrefix:@"oliver"]) {
            NSArray * gateArr = [gateStr componentsSeparatedByString:@":"];
            AduroGateway * gateway = [[AduroGateway alloc] init];
            gateway.gatewayID   = gateArr[0];
            gateway.gatewayName = gateArr[1];
            gateway.gatewayIPv4Address = gateArr[2];
            model.netModel      = NetTypeLocal;
            [Lee_Notification postNotificationName:Lee_GET_GATEWAY object:gateway];
        }else{
            DLog(@"局域网反馈的数据::%@",gateStr);
            [AduroDataTool getTheData:nil];
            
            [Lee_Notification postNotificationName:Lee_FIND_DEVICE object:nil];
            
        }
  
    }else{
    
        DLog(@"解析服务器数据");
    }
   

}
@end
