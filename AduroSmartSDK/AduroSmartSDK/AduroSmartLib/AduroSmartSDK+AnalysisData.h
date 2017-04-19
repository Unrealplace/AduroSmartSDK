//
//  AduroSmartSDK+AnalysisData.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/19.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "AduroSmartSDK.h"
@class NetTypeModel;

@interface AduroSmartSDK (AnalysisData)

-(void)AnalysisData:(id)data withNetModel:(NetTypeModel*)model;

@end
