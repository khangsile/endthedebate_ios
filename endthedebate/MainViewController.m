//
//  MainViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "MainViewController.h"

#import "QuestionViewController.h"

#import "KLKeyBoardbar.h"

#import <UIViewController+JASidePanel.h>
#import <JASidePanelController.h>

@interface MainViewController ()

@property (nonatomic, strong) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet KLKeyboardBar *searchBar;
@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSMutableArray *questions;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Disputed";
    self.sidePanelController.leftPanel = [[UIViewController alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setUpView];
    NSMutableArray *resizeViews = [[NSMutableArray alloc] initWithArray:@[self.tableview]];
    [self.searchBar setResizeViews:resizeViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = @"Question";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionViewController *questionController = [[QuestionViewController alloc] init];
    [self.navigationController pushViewController:questionController animated:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - ViewSetUp

/**
 Nib files are the fucking worst
 */
- (void)setUpView
{
    CGRect tabBarFrame = self.tabBar.frame;
    tabBarFrame.origin.y = 0;
    tabBarFrame.size.height = 49;
    self.tabBar.frame = tabBarFrame;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    CGRect searchBarFrame = self.searchBar.frame;
    searchBarFrame.origin.y =  window.frame.size.height - searchBarFrame.size.height;
    //self.searchBar.frame = searchBarFrame;
    
    CGRect tableviewFrame = self.tableview.frame;
    tableviewFrame.origin.y = self.tabBar.frame.size.height;
    tableviewFrame.size.height = searchBarFrame.origin.y - tabBarFrame.origin.y;
    self.tableview.frame = tableviewFrame;
}

#pragma mark - Buttons

- (IBAction)search:(id)sender
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

@end
