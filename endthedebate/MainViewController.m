//
//  MainViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "MainViewController.h"

#import "KLKeyBoardbar.h"

@interface MainViewController ()

@property (nonatomic, strong) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet KLKeyboardBar *searchBar;
@property (nonatomic, strong) IBOutlet UITextField *textField;

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
    CGRect tabBarFrame = self.tableview.frame;
    tabBarFrame.origin.y = 0;
    tabBarFrame.size.height = 49;
    self.tabBar.frame = tabBarFrame;
    
    CGRect tableviewFrame = self.tableview.frame;
    tableviewFrame.origin.y = self.tabBar.frame.size.height;
    self.tableview.frame = tableviewFrame;
}

@end
