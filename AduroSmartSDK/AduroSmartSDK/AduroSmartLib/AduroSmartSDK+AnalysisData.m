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

    NSData * gatedata =  data[Lee_Gateway];
    if (gatedata != nil) {
        NSString * gateStr = [[NSString alloc] initWithData:gatedata encoding:NSUTF8StringEncoding];
        if ([gateStr hasPrefix:@"GZ3"]) {
            DLog(@"%@",gateStr);
            NSData   * tranlateData = [AduroDataTool analysisGateData:gatedata];
            NSString * newGateStr   = [[NSString alloc] initWithData:tranlateData encoding:NSUTF8StringEncoding];

            NSArray * gateArr   = [newGateStr componentsSeparatedByString:@" "];
            NSArray * IDArr     = [gateArr[0] componentsSeparatedByString:@"-"];
            AduroGateway * gateway = [[AduroGateway alloc] init];
            gateway.gatewayID   = IDArr[1];
            gateway.gatewayName = gateArr[0];
            gateway.gatewayIPv4Address = data[Lee_GateIP];
            model.netModel      = NetTypeLocal;
            [Lee_Notification postNotificationName:Lee_GET_GATEWAY object:gateway];
        }else{
            DLog(@"局域网控制指令反馈的数据::%@",gatedata);
            NSData* backData = [AduroDataTool analysisLocalData:gatedata.mutableCopy];
            NSData * typeData = [backData subdataWithRange:NSMakeRange(9, 2)];
            uint16_t type     = *(int *)[typeData bytes];
            [self analysisDataWith:backData andType:type];
        }
  
    }else{
    
        DLog(@"解析服务器数据");
    }
   
}

-(void)analysisDataWith:(NSData*)data andType:(uint16_t)type{

    switch (type) {
        case GATE_CMD_GTW_INF :{
            NSData * devCodeData = [data subdataWithRange:NSMakeRange(0, 8)];
            NSData * commondSetData = [data subdataWithRange:NSMakeRange(9, 2)];
            NSData * lengthData  = [data subdataWithRange:NSMakeRange(11, 2)];
            NSData * crcData   = [data subdataWithRange:NSMakeRange(data.length - 3, 2)];
            NSData * devData   = [data subdataWithRange:NSMakeRange(13, data.length-4)];
            NSData * stateData = [devData subdataWithRange:NSMakeRange(0, 1)];
            NSData * gateNameData = [devData subdataWithRange:NSMakeRange(9, 20)];
            
            DLog(@"%@",[[NSString alloc] initWithData:gateNameData encoding:NSUTF8StringEncoding]);
            
            [Lee_Notification postNotificationName:Lee_FIND_DEVICE object:nil];

        }
            break;
            
        default:
            break;
    }
}

@end
