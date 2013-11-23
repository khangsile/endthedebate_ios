//
//  LoginViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"
#import "MainViewController.h"

#import <RestKit.h>

@interface LoginViewController ()

- (IBAction)buttonClickHandler:(id)sender;
- (void)updateView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self updateView];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }
}

// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
}

// handler for button click, logs sessions in or out
- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            if (status != FBSessionStateOpen) return;
            
            NSString *accessToken = [[session accessTokenData] accessToken];
            NSLog(@"%@", accessToken);
            NSLog(@"%@", [[session accessTokenData] expirationDate]);
            RKObjectManager *manager = [RKObjectManager sharedManager];
            
            NSMutableURLRequest *request = [manager requestWithObject:nil
                                                               method:RKRequestMethodPOST
                                                                 path:@"facebook_login.json"
                                                           parameters:nil];
            [request setValue:accessToken forHTTPHeaderField:@"OAUTH"];
                        
            RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
                    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                        [self presentViewController:[[MainViewController alloc] init] animated:NO completion:nil];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                NSLog(@"Fail");
            }];
            
            [operation start];
            
        }];
    }
}

#pragma mark Template generated code

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark -

@end
