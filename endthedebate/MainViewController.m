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

/**
 tabBar to switch between hot, new, top modes
 */
@property (nonatomic, strong) IBOutlet UITabBar *tabBar; //tab bar
/**
 TableView to hold all of the questions
 */
@property (nonatomic, strong) IBOutlet UITableView *tableview; // tableview
/**
 keyboard bar to hold the search bar
 */
@property (nonatomic, strong) IBOutlet KLKeyboardBar *searchBar; // search
/**
 TextField to type the search in
 */
@property (nonatomic, strong) IBOutlet UITextField *textField; // search
/**
 QuestionCell to generate heights for the cells to be displayed
 */
@property (nonatomic, strong) QuestionCell *offscreenCell; // dynamic cell sizes
/**
 Mutable array to hold the questions to be shown in the tableview
 */
@property (nonatomic, strong) NSMutableArray *questions; // table view data source

/**
 NSUInteger to hold which page we are on (for pagination)
 */
@property (nonatomic) NSUInteger pageNo; //pagination
/**
 String to determine how to sort the questions
 */
@property (nonatomic, strong) NSString *sortBy; //pagination
/**
 Boolean to determine if the page is loading questions
 */
@property (atomic) BOOL isLoading;
/**
 Boolean to determine if the page results are search results
 */
@property (nonatomic) BOOL searching;
/**
 Boolean to determine if there are no questions (empty)
 */
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
    
    // Set up views to be resized when the keyboard comes up
    NSMutableArray *resizeViews = [[NSMutableArray alloc] initWithArray:@[self.tableview]];
    [self.searchBar setResizeViews:resizeViews];
    
    // Set up the cells to be used in the table
    UINib *nib = [UINib nibWithNibName:kQuestionCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:kQuestionCell];
    self.offscreenCell = [self.tableview dequeueReusableCellWithIdentifier:kQuestionCell];
    self.offscreenCell.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.offscreenCell.questionLabel.numberOfLines = 0;
    
    // Initialize the tabBar to be initially set to top
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

/**
 Returns the number of sections in the table view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 Returns the number of rows in the tableview (the number of questions)
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.questions count];
}

/**
 Gets the height for each cell at the given index path
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    
    //Simulate what the cell will look like in the tableview
    self.offscreenCell.questionLabel.text = question.question;
    // Use layout subviews to enlarge the cell so that it can fit
    // all of its content
    [self.offscreenCell layoutSubviews];
    
    // Return this size
    return self.offscreenCell.requiredCellHeight;
}

/**
 Create a cell for each question in the NSMutableArray of questions
 */
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

/**
 Go to the question screen if the cell has not yet been answered. If it has, then go to the results page.
 */
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

/**
 Switch the way the cells are organized (by hot, top, new)
 */
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

/**
 Set up the placement of the pages
 */
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

/**
 Search for a question with the given query in the searchField
 */
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

/**
 Load questions according to the page number and sorting type
 */
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

/**
 Add a question only if it is not in the list currently.
 This is done to avoid duplicates during the pagination process.
 */
- (void)addQuestion:(Question*)question
{
    for (Question *_question in self.questions) {
        if (question.questionId == _question.questionId) return;
    }
    
    [self.questions addObject:question];
}

@end
