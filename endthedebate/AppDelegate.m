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
#import "LeftSidePanelViewController.h"

//Models
#import "User.h"
#import "Question.h"
#import "Answer.h"

#import <RestKit.h>

#import <JASidePanels/UIViewController+JASidePanel.h>
#import <JASidePanelController.h>

@interface AppDelegate()

@property (nonatomic, strong) UINavigationController *mainController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self setUpRestKit];
    
    JASidePanelController *jaController = [[JASidePanelController alloc] init];
    
    self.mainController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    jaController.leftPanel = [[LeftSidePanelViewController alloc] init];
    jaController.centerPanel = self.mainController;
    
    self.viewController = jaController;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *authToken = [defaults objectForKey:@"auth_token"];
    
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];

    [self.mainController presentViewController:[[LoginViewController alloc] init] animated:NO completion:nil];
    
    if (!authToken) {
//        if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
//            NSString *authToken = [[FBSession activeSession].accessTokenData accessToken];
//            [User login:authToken success:^(User *activeUser) {
//                [jaController dismissViewControllerAnimated:NO completion:nil];
//            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                NSLog(@"Something bad happened");
//            }];
//        }
    } else {
        User *user = [User new];
        user.authToken = authToken;
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[FBSession activeSession]];
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
    
    [FBAppCall handleDidBecomeActiveWithSession:[FBSession activeSession]];
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
    [manager addResponseDescriptor:[Answer getResponseMapping]];
    [manager addRequestDescriptor:[Question getRequestMapping]];
    
    [RKObjectManager setSharedManager:manager];
}

#pragma mark - Facebook

//show login - Facebook passes login for iOS SDK through Safari
- (void)showLoginView
{
    UIViewController *modalViewController = [self.mainController presentedViewController];
    
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController"
                                                                                         bundle:nil];
        [self.mainController presentViewController:loginViewController animated:NO completion:nil];
    } 
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            [self login:session.accessTokenData.accessToken];
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        NSString *errorTitle = NSLocalizedString(@"Error", @"Facebook Connect");
        NSString *errorMessage = [error localizedDescription];
        
        //If user denies permission (clicks cancel at login or failed login)
        if (error.code == FBErrorLoginFailedOrCancelled) {
            errorTitle = NSLocalizedString(@"Facebook Login Failed", @"Facebook Connect");
            errorMessage = NSLocalizedString(@"Please allow our application to use Facebook in your Privacy settings.", @"Facebook Connect");
            //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            //[tracker sendEventWithCategory:@"login" withAction:@"permissionDenied" withLabel:@"loginButton" withValue:[NSNumber numberWithInt:1]];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:errorTitle
                                                            message:errorMessage delegate:nil
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

//Open Facebook Session for user and set extra permissions
- (void)openSession
{
    // permissions past basic permissions
    NSArray *permissions = [NSArray arrayWithObjects:@"user_about_me", @"email", @"user_photos", @"read_friendlists", nil];
    
    //direct user to login
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    BOOL result = NO;
    NSArray *permissions = [NSArray arrayWithObjects:@"user_about_me", @"email", @"user_photos", @"read_friendlists", nil];
    FBSession *session = [[FBSession alloc] initWithAppID:nil permissions:permissions urlSchemeSuffix:nil tokenCacheStrategy:nil];
    
    if (allowLoginUI || (session.state == FBSessionStateCreatedTokenLoaded)) {
        [FBSession setActiveSession:session];
        [session openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
        }];
        result = session.isOpen;
    }
    return result;
}

// FB SDK does not fully log you out (ie press logout and check Safari)
// Users must logout in Safari (due to Facebook's SSO policy) Single Sign On
- (void)closeSession
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    //[self showLoginView];
}

- (void)login:(NSString*)authToken
{
    [User login:authToken success:^(User *activeUser) {
        [self.mainController dismissViewControllerAnimated:NO completion:nil];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Something bad happened");
    }];

}



@end
