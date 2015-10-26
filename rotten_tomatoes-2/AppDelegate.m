//
//  AppDelegate.m
//  rotten_tomatoes-2
//
//  Created by Matias Arenas Sepulveda on 10/22/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MoviesViewController *boxOfficeVC = [[MoviesViewController alloc] initWithType:MoviesViewControllerTypeBoxOffice];
    UINavigationController* boxOfficeNVC = [[UINavigationController alloc] initWithRootViewController:boxOfficeVC];
    boxOfficeNVC.tabBarItem.image = [UIImage imageNamed:@"Box Office Image"];
    boxOfficeNVC.tabBarItem.title = @"Box Office";
    [boxOfficeNVC.navigationBar setBarTintColor:[UIColor colorWithRed:0.55 green:0.76 blue:0.29 alpha:1.0]];
    
    MoviesViewController *dvdVC = [[MoviesViewController alloc] initWithType:MoviesViewControllerTypeDvd];
    UINavigationController* dvdNVC = [[UINavigationController alloc] initWithRootViewController:dvdVC];
    dvdNVC.tabBarItem.image = [UIImage imageNamed:@"DVD Image"];                            
    dvdNVC.tabBarItem.title = @"Top DVDs";
    [dvdNVC.navigationBar setBarTintColor:[UIColor colorWithRed:0.00 green:0.74 blue:0.83 alpha:1.0]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[boxOfficeNVC, dvdNVC];
    
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
