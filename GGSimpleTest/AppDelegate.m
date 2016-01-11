//
//  AppDelegate.m
//  GGSimpleTest
//
//  Created by viethq on 8/28/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "AppDelegate.h"
#import <MFSideMenu/MFSideMenu.h>
#import "GGLeftMenu.h"
#import "GGDrawView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /* xoa viewcontroller o default project, tao window roi add customview cua minh vao
    xoa mainstoryboard va gia tri trong  key "mainstoryboard file base name" o info.plist
     */
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // tao slide menu va add vao trong navigation
    GGLeftMenu *pLeftMenu = [[GGLeftMenu alloc] initWithNibName:nil bundle:nil];
    GGDrawView *pDrawVC = [[GGDrawView alloc] initWithNibName:nil bundle:nil];
    UINavigationController *pNav = [[UINavigationController alloc] initWithRootViewController:pDrawVC];
    MFSideMenuContainerViewController *pContainer = [MFSideMenuContainerViewController
                                                     containerWithCenterViewController:pNav
                                                     leftMenuViewController:pLeftMenu
                                                     rightMenuViewController:nil];
    
    CGRect mnFrame = pLeftMenu.view.frame;
    mnFrame.origin.y = 20.0f;
    mnFrame.size.height -= 20.0f;
    pLeftMenu.view.frame = mnFrame;
    
    pContainer.shadow.radius = 3.0f;
    self.window.rootViewController = pContainer;
    
    [self.window makeKeyAndVisible]; // need this line
    
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
