//
//  MainViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "MainViewController.h"

#import "QuestionViewController.h"
#import "CreateQuestionViewController.h"

#import "Question.h"

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
        self.title = @"Disputed";
        self.questions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    
    NSMutableArray *resizeViews = [[NSMutableArray alloc] initWithArray:@[self.tableview]];
    [self.searchBar setResizeViews:resizeViews];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    [Question getQuestions:0 pageSize:0 success:^(NSMutableArray *questions) {
        [self.questions addObjectsFromArray:questions];
        [self.tableview reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Something went wrong");
    }];
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
    return [self.questions count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    cell.textLabel.text = question.question;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    
    QuestionViewController *questionController = [[QuestionViewController alloc] initWithQuestion:question];
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
