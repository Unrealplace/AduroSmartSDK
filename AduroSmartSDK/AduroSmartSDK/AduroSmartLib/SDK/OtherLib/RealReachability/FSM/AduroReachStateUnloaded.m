//
//  ReachStateUnloaded.m
//  RealReachability
//
//  Created by Dustturtle on 16/1/19.
//  Copyright © 2016 Dustturtle. All rights reserved.
//

#import "AduroReachStateUnloaded.h"

@implementation AduroReachStateUnloaded

- (RRStateID)onEvent:(NSDictionary *)event withError:(NSError **)error
{
    RRStateID resStateID = RRStateUnloaded;
    
    NSNumber *eventID = event[kEventKeyID];
    
    switch ([eventID intValue])
    {
        case RREventLoad:
        {
            resStateID = RRStateLoading;
            break;
        }
        default:
        {
            if (error != NULL)
            {
                *error = [NSError errorWithDomain:@"FSM" code:kFSMErrorNotAccept userInfo:nil];
            }
            break;
        }
    }
    return resStateID;
}

@end
