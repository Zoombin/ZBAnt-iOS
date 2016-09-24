//
//  AppDelegate.m
//  ZBAnt
//
//  Created by zhangbin on 4/4/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "AppDelegate.h"
#import "ZBAnt.h"
#import "ZBStatisticsViewController.h"
#import "ZBServersViewController.h"
#import "ZBNewrankViewController.h"

@interface AppDelegate ()

@property (nonatomic, readwrite) ZBAnt *ant;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	ZBServersViewController *serversViewController = [[ZBServersViewController alloc] init];
	serversViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Servers" image:[UIImage imageNamed:@"first"] tag:1];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:serversViewController];
	
	ZBStatisticsViewController *statisticsViewController = [[ZBStatisticsViewController alloc] init];
	statisticsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Weiboyi" image:[UIImage imageNamed:@"second"] tag:0];
	UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:statisticsViewController];
	
	ZBNewrankViewController *newrankViewController = [[ZBNewrankViewController alloc] init];
	newrankViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Newrank" image:[UIImage imageNamed:@"first"] tag:1];
	UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:newrankViewController];
	
	UITabBarController *tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
	tabBarController.viewControllers = @[nav, nav2, nav3];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//	NSString *deviceName = [[[UIDevice currentDevice] name] mutableCopy];
//	NSLog(@"deviceName: %@", deviceName);
//	
//	NSString *systemName = [[UIDevice currentDevice] systemName];
//	NSLog(@"systemName: %@", systemName);
//	
//	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
//	NSLog(@"systemVersion: %@", systemVersion);
//	
//	NSString *model = [[UIDevice currentDevice] model];
//	NSLog(@"model: %@", model);
//	
//	NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
//	NSLog(@"uuid: %@", [uuid UUIDString]);
//	
//	NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
//	NSLog(@"bundleid: %@", bundleIdentifier);
//	
//	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//	NSLog(@"version: %@", version);
//	
//	NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//	NSLog(@"build: %@", build);
	
	_ant = [[ZBAnt alloc] init];
	[_ant start];
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
