//
//  AppDelegate.m
//  NextApp
//
//  Created by lihui on 2017/3/2.
//  Copyright © 2017年 appgo. All rights reserved.
//

#import "AppDelegate.h"
#import "NAEntryTableViewController.h"
#import "NANavigator.h"
#import "NARouter+Load.h"
#import <WeexSDK/WeexSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NAEntryTableViewController *entryVC = [NAEntryTableViewController new];
    
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:entryVC];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [NANavigator sharedInstance].navigationController = navigationController;
    
    [NARouter loadAllScheme];

    [self setupWeexConfiguration];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupWeexConfiguration {
    //business configuration
    [WXAppConfiguration setAppGroup:@"NextAppGroup"];
    [WXAppConfiguration setAppName:@"NextApp"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    //init sdk enviroment
    [WXSDKEngine initSDKEnviroment];
    
    //register custom module and component，optional
//    [WXSDKEngine registerComponent:@"MyView" withClass:[MyViewComponent class]];
//    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    //register the implementation of protocol, optional
//    [WXSDKEngine registerHandler:[WXNavigationDefaultImpl new] withProtocol:@protocol(WXNavigationProtocol)];
    //set the log level
    [WXLog setLogLevel: WXLogLevelAll];
}

@end
