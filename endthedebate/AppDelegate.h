//
//  AppDelegate.h
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>

// Session Login For Facebook

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)showLoginView;
- (void)closeSession;


@end
