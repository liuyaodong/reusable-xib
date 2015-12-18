//
//  AppDelegate.m
//  ReusableXIB
//
//  Created by liuyaodong on 11/30/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import <WeiboSDK/WeiboSDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK registerApp:kAppKey];
    [WeiboSDK enableDebugMode:YES];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:(MasterViewController *)((UINavigationController *)self.window.rootViewController).topViewController];
}

@end
