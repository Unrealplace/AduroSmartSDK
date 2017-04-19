//
//  NetTypeModel.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/19.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "NetTypeModel.h"

@implementation NetTypeModel
-(instancetype)init{

    if (self = [super init]) {
        _netModel = NetTypeRemote;
    }
    return self;
}
@end
