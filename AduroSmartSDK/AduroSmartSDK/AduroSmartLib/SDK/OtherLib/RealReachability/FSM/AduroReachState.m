//
//  ReachState.m
//  RealReachability
//
//  Created by Dustturtle on 16/1/19.
//  Copyright © 2016 Dustturtle. All rights reserved.
//

#import "AduroReachState.h"

@implementation AduroReachState

+ (id)state
{
    return [[self alloc] init];
}

- (RRStateID)onEvent:(NSDictionary *)event withError:(NSError **)error
{
    return RRStateInvalid;
}

@end
