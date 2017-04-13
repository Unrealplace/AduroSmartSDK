//
//  ReachStateUnReachable.m
//  RealReachability
//
//  Created by Dustturtle on 16/1/19.
//  Copyright © 2016 Dustturtle. All rights reserved.
//

#import "AduroReachStateUnReachable.h"

@implementation AduroReachStateUnReachable

- (RRStateID)onEvent:(NSDictionary *)event withError:(NSError **)error
{
    RRStateID resStateID = RRStateUnReachable;
    
    NSNumber *eventID = event[kEventKeyID];
    
    switch ([eventID intValue])
    {
        case RREventUnLoad:
        {
            resStateID = RRStateUnloaded;
            break;
        }
        case RREventPingCallback:
        {
            NSNumber *eventParam = event[kEventKeyParam];
            resStateID = [AduroFSMStateUtil RRStateFromPingFlag:[eventParam boolValue]];
            break;
        }
        case RREventLocalConnectionCallback:
        {
            resStateID = [AduroFSMStateUtil RRStateFromValue:event[kEventKeyParam]];
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
