//
//  AppDelegate.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "MainViewController.h"
#import "QuestionViewController.h"

//Models
#import "User.h"
#import "Question.h"
#import "Answer.h"

#import <RestKit.h>

#import <JASidePanels/UIViewController+JASidePanel.h>
#import <JASidePanelController.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self setUpRestKit];
    [self setSession:[FBSession activeSession]];
    
    
    JASidePanelController *jaController = [[JASidePanelController alloc] init];
    
    UINavigationController *mainController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    jaController.leftPanel = [[QuestionViewController alloc] init];
    jaController.centerPanel = mainController;
    
    self.viewController = ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) ?
        jaController : [[LoginViewController alloc] init];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
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
    
    [FBAppEvents activateApp];
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    

}

/**
 */
- (void)setUpRestKit
{
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://disputed.herokuapp.com/api"]];
    [manager.HTTPClient setDefaultHeader:@"CONTENT-TYPE" value:@"application/json"];

    //Set request/response descriptors
    [manager addResponseDescriptor:[User getResponseMapping]];
    [manager addResponseDescriptor:[Question getResponseMapping]];
    [manager addRequestDescriptor:[Question getRequestMapping]];
    
    [RKObjectManager setSharedManager:manager];
}


@end
