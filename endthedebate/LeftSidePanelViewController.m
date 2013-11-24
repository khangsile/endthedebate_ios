//
//  QuestionPage.m
//  endthedebate
//
//  Created by Cody Hughes on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//



#import "LeftSidePanelViewController.h"

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
        [NSArray arrayWithObjects: @"Submit a Question", @"Log Out",nil];
    }
    return self;
    
    
    
}

- (void)viewDidLoad
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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

#pragma mark - UITextField Delegate

/**- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    return NO;
}*/

#pragma mark - ViewSetUp

/**
 Nib files are the fucking worst
 */
- (void)setUpView
{
    /**CGRect tabBarFrame = self.tabBar.frame;
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
    self.tableview.frame = tableviewFrame;*/
}

#pragma mark - Buttons

@end