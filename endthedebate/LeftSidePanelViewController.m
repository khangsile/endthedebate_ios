//
//  QuestionPage.m
//  endthedebate
//
//  Created by Cody Hughes on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "LeftSidePanelViewController.h"

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "CreateQuestionViewController.h"
#import "HistoryViewController.h"

#import <JASidePanelController.h>
#import <UIViewController+JASidePanel.h>

@interface LeftSidePanelViewController()

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSMutableArray *navigationItems;

@end

@implementation LeftSidePanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItems = [[NSMutableArray alloc] initWithArray:@[@"Submit a Question", @"History", @"Logout"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.navigationItems count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.navigationItems objectAtIndex:[indexPath row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath row]) {
        case 0:
            [(UINavigationController*) self.sidePanelController.centerPanel pushViewController:[CreateQuestionViewController new] animated:YES];
            break;
        case 1: {
            [(UINavigationController*) self.sidePanelController.centerPanel
             pushViewController:[HistoryViewController new] animated:YES];
        }
            break;
        case 2: {
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate closeSession];
        }
            break;
        default:
            break;
    }
    [self.sidePanelController showCenterPanelAnimated:YES];
}

@end