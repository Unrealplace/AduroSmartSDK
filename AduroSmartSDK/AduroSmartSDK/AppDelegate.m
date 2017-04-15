//
//  AppDelegate.m
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "AppDelegate.h"
#import "AduroSmartSDK.h"
#import "DeviceViewController.h"
#import "GateViewController.h"
#import "ASBaseTabBarController.h"
#import "ASBaseNavigationController.h"
#define Lee_Stau @"Status"
#define Lee_Userdefault   [NSUserDefaults standardUserDefaults]

@interface AppDelegate ()
@property(nonatomic,strong)ASBaseTabBarController * baseTabBar;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [AduroSmartSDK sharedManager];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _baseTabBar = [ASBaseTabBarController new];
    ASBaseNavigationController * deviceVC = [[ASBaseNavigationController alloc] initWithRootViewController:[DeviceViewController new]];
    ASBaseNavigationController * gatewayVC = [[ASBaseNavigationController alloc] initWithRootViewController:[GateViewController new]];
    _baseTabBar.viewControllers = @[deviceVC,gatewayVC];
    deviceVC.tabBarItem.title   = @"device";
    gatewayVC.tabBarItem.title  = @"gateway";
    self.window.rootViewController = _baseTabBar;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [Lee_Userdefault setValue:@"background" forKey:Lee_Stau];
    [Lee_Userdefault synchronize];
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [Lee_Userdefault setValue:@"foreground" forKey:Lee_Stau];
    [Lee_Userdefault synchronize];
    

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [Lee_Userdefault setValue:@"foreground" forKey:Lee_Stau];
    [Lee_Userdefault synchronize];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
