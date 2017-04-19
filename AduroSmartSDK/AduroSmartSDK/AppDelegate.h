//
//  AppDelegate.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

extern AppDelegate * appdelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign)BOOL isRometControl;

@end

