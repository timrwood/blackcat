//
//  AppDelegate.m
//  BlackCat
//
//  Created by Tim Wood on 12/29/11.
//  Copyright (c) 2011 Broken Pixel Studios. All rights reserved.
//


#import "BCGlobalManager.h"
#import "BCAppDelegate.h"
#import "BCViewController.h"

#import "AHTimeManager.h"
#import "AHSuperSystem.h"


@implementation BCAppDelegate


@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[BCViewController alloc] initWithNibName:@"BCViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[BCViewController alloc] initWithNibName:@"BCViewController_iPad" bundle:nil];
    }
    
    // init super system
    [[AHSuperSystem manager] setup];
    [[AHSuperSystem manager] setDelegate:[BCGlobalManager manager]];
    //[[AHSuperSystem manager] setDebugDraw:YES];
    //[[AHSuperSystem manager] setRenderDraw:NO];
    
    // setup fps
    [self.viewController setPreferredFramesPerSecond:30];
    [[AHTimeManager manager] setFramesPerSecond:[self.viewController framesPerSecond]];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    if (NO) {
        [self.viewController setPreferredFramesPerSecond:5];
        [[AHTimeManager manager] setWorldToRealRatio:6];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[AHSuperSystem manager] teardown];
}

@end
