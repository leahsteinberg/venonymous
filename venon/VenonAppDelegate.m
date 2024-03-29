//
//  VenonAppDelegate.m
//  venon
//
//  Created by Leah Steinberg on 6/30/14.
//  Copyright (c) 2014 LeahSteinberg. All rights reserved.
//

#import "VenonAppDelegate.h"
#import <Venmo-iOS-SDK/Venmo.h>


@implementation VenonAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Venmo startWithAppId:@"1790" secret:@"C5rrBwhWkzV5yzDwv3fEGpXbJmeaAx2J" name:@"Venonymous"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    if ([[Venmo sharedInstance] isSessionValid]) {
        UIViewController *navController = [mainStoryboard instantiateViewControllerWithIdentifier:@"NavVC"];
        self.window.rootViewController = navController;
    }
    else {
        UIViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        self.window.rootViewController = loginVC;
    }
    return YES;
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[Venmo sharedInstance] handleOpenURL:url]) {
        return YES;
    }
    // You can add your app-specific url handling code here if needed
    return NO;
}


@end
