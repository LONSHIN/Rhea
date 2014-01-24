//
//  REAppDelegate.m
//  Rhea
//
//  Created by Tiger on 13-12-24.
//  Copyright (c) 2013年 Tiger. All rights reserved.
//

#import "REAppDelegate.h"
#import "REHomePageViewController.h"
#import "WXApi.h"
#import "MobClick.h"
#import "REAddCarViewController.h"

@interface REAppDelegate ()
<WXApiDelegate>

@end


@implementation REAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [WXApi registerApp:kWechatAppID];
    [MobClick startWithAppkey:kUmengAPPKEY];
    
    REHomePageViewController *vc = [[REHomePageViewController alloc] init];
   
    RENavigationController *navc = [[RENavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeChatRequest object:nil userInfo:@{kNotificationUserInfoKeyWeChatRequest: req}];
}


- (void)onResp:(BaseResp *)resp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeChatResponse object:nil userInfo:@{kNotificationUserInfoKeyWeChatResponse: resp}];
}


@end
