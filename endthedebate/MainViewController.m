//
//  MainViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "MainViewController.h"

#import "QuestionViewController.h"
#import "ResultsViewController.h"
#import "MapResultViewController.h"
#import "ResultsPageViewController.h"

#import "Question.h"
#import "User.h"

#import "QuestionCell.h"

#import "KLKeyBoardbar.h"

#import <UIViewController+JASidePanel.h>
#import <JASidePanelController.h>

#define kQuestionCell @"QuestionCell"
#define kNoPerPage 5

@interface MainViewController ()

@property (nonatomic, strong) IBOutlet UITabBar *tabBar; //tab bar
@property (nonatomic, strong) IBOutlet UITableView *tableview; // tableview
@property (nonatomic, strong) IBOutlet KLKeyboardBar *searchBar; // search
@property (nonatomic, strong) IBOutlet UITextField *textField; // search

@property (nonatomic, strong) QuestionCell *offscreenCell; // dynamic cell sizes

@property (nonatomic, strong) NSMutableArray *questions; // table view data source

@property (nonatomic) NSUInteger pageNo; //pagination
@property (nonatomic, strong) NSString *sortBy; //pagination
@property (atomic) BOOL isLoading;
@property (nonatomic) BOOL searching;
@property (nonatomic) BOOL isEmpty;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"End the Debate";
        self.sortBy = @"trending";
        self.pageNo = 0;
        self.isLoading = NO;
        self.isEmpty = NO;
        self.searching = NO;
        self.questions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self setUpView];
    
    NSMutableArray *resizeViews = [[NSMutableArray alloc] initWithArray:@[self.tableview]];
    [self.searchBar setResizeViews:resizeViews];
    
    UINib *nib = [UINib nibWithNibName:kQuestionCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:kQuestionCell];
    self.offscreenCell = [self.tableview dequeueReusableCellWithIdentifier:kQuestionCell];
    self.offscreenCell.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.offscreenCell.questionLabel.numberOfLines = 0;
    
    UITabBarItem *item = [self.tabBar.items objectAtIndex:0];
    [self.tabBar setSelectedItem:item];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadQuestions];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    
    self.offscreenCell.questionLabel.text = question.question;
    [self.offscreenCell layoutSubviews];
    
    return self.offscreenCell.requiredCellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCell *cell = (QuestionCell*)[tableView dequeueReusableCellWithIdentifier:kQuestionCell forIndexPath:indexPath];
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    cell.questionLabel.text = question.question;
    
    cell.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.questionLabel.numberOfLines = 0;
    cell.votesCountLabel.text = [NSString stringWithFormat:@"%d", question.votesCount];
    
    if ([self.questions count] - [indexPath row] < 3 && !self.isLoading && !self.isEmpty && !self.searching) {
        self.isLoading = YES;
        self.pageNo++;
        [self loadQuestions];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    
    [Question getQuestion:question.questionId forUser:[User activeUser] success:^(Question *question) {
        if (![question answered]) {
            QuestionViewController *questionController = [[QuestionViewController alloc] initWithQuestion:question];
            [self.navigationController pushViewController:questionController animated:YES];
        } else {
            ResultsPageViewController *resultsController = [[ResultsPageViewController alloc] initWithArray:question.answers forQuestion:question];
            [self.navigationController pushViewController:resultsController animated:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Something is going wrong on MainViewController");
        NSLog(@"%@", operation.HTTPRequestOperation.responseString);
    }];
}

#pragma mark - UITabBar Delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.searching = NO;
    self.sortBy = [item.title lowercaseString];
    [self.questions removeAllObjects];
    self.isEmpty = NO;
    self.pageNo = 0;
    [self loadQuestions];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.textField) {
        [self search:textField];
        [textField resignFirstResponder];
    }
    return NO;
}

#pragma mark - ViewSetUp

- (void)setUpView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect tabBarFrame = self.tabBar.frame;
    tabBarFrame.origin.y = 0;
    tabBarFrame.size.height = 49;
    //self.tabBar.frame = tabBarFrame;
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    CGRect searchBarFrame = self.searchBar.frame;
    searchBarFrame.origin.y =  window.frame.size.height - searchBarFrame.size.height;
    self.searchBar.frame = searchBarFrame;
    
    CGRect tableviewFrame = self.tableview.frame;
    tableviewFrame.origin.y = self.tabBar.frame.size.height;
    tableviewFrame.size.height = searchBarFrame.origin.y - tabBarFrame.origin.y;
    self.tableview.frame = tableviewFrame;
}

#pragma mark - Buttons

- (IBAction)search:(id)sender
{
    self.searching = YES;
    
    [Question search:[self.textField text] success:^(NSMutableArray *questions) {
        [self.questions removeAllObjects];
        
        for (Question *question in questions) [self addQuestion:question];
        
        self.isLoading = NO;
        [self.tableview reloadData];
        [self.textField resignFirstResponder];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
       // Do nothing
        NSLog(@"%@", operation.HTTPRequestOperation.responseString);
    }];
}

#pragma mark - Helper

- (void)loadQuestions
{
    [Question getQuestions:self.pageNo pageSize:kNoPerPage sortBy:self.sortBy success:^(NSMutableArray *questions) {
        if ([questions count] == 0) self.isEmpty = YES;
        
        for (Question *question in questions) [self addQuestion:question]; //necessary for avoiding duplicates

        self.isLoading = NO;
        [self.tableview reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Something went wrong");
        NSLog(@"%@", operation.HTTPRequestOperation.responseString);
    }];
}

- (void)addQuestion:(Question*)question
{
    for (Question *_question in self.questions) {
        if (question.questionId == _question.questionId) return;
    }
    
    [self.questions addObject:question];
}

@end
