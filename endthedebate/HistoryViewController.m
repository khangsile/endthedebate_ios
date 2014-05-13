//
//  HistoryViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/24/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "HistoryViewController.h"

#import "QuestionViewController.h"
#import "ResultsPageViewController.h"

#import "Question.h"
#import "User.h"

#import "QuestionCell.h"

#define kQuestionCell @"QuestionCell"

@interface HistoryViewController ()

/**
 The tableview to hold the previous questions that the user has answered
 */
@property (nonatomic, strong) IBOutlet UITableView *tableview;
/**
 The off screen cell to be used to be used to determine the height of each cell
 */
@property (nonatomic, strong) QuestionCell *offscreenCell;
/**
 An array of the questions in the user's history
 */
@property (nonatomic, strong) NSMutableArray *questions;

@end

@implementation HistoryViewController

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
    // Do any additional setup after loading the view from its nib.
    [self loadQuestions];
    
    // Load the nib to register the question cell
    UINib *nib = [UINib nibWithNibName:kQuestionCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:kQuestionCell];
    
    self.offscreenCell = [self.tableview dequeueReusableCellWithIdentifier:kQuestionCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

/**
 Returns the number of sections in the tableview
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 Returns the number of rows in the tableview (number of questions)
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.questions count];
}

/**
 Set the height of the cell for the given question (indexPath)
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    
    // Create the cell to simulate what it will look like onscreen
    self.offscreenCell.questionLabel.text = question.question;
    // Layout subviews makes the cell larger so that it is large enough to fit all its content
    [self.offscreenCell layoutSubviews];
    
    // Return the offscreenCell's height
    return self.offscreenCell.requiredCellHeight;
}

/**
 Create the cell that holds a question
 */
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCell *cell = (QuestionCell*)[tableView dequeueReusableCellWithIdentifier:kQuestionCell forIndexPath:indexPath];
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    cell.questionLabel.text = question.question;
    cell.votesCountLabel.text = [NSString stringWithFormat:@"%d", question.votesCount];
    
    cell.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.questionLabel.numberOfLines = 0;
    
    return cell;
}

/**
 React to the user clicking a question in the history list. If the question is answered, then
 it will go straight to the results page. If not, then it will go straight to the question page.
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
        NSLog(@"%@", operation.HTTPRequestOperation.responseString); // Do nothing if it fails, but log it
    }];
}

#pragma mark - Helper

/**
 Load the questions from the user's history
 */
- (void)loadQuestions
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    User *user = [User activeUser];
    
    NSString *path = [NSString stringWithFormat:@"users/%d/questions.json", user.userId];
    
    NSMutableURLRequest *request = [manager requestWithObject:nil
                                                       method:RKRequestMethodGET
                                                         path:path
                                                   parameters:nil];
    // Requires an auth-token and email to find which user's history to get
    [request setValue:user.authToken forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [request setValue:user.email forHTTPHeaderField:@"X-USER-EMAIL"];
    
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"%@", operation.HTTPRequestOperation.responseString);
            self.questions = [NSMutableArray arrayWithArray:[mappingResult array]];
            [self.tableview reloadData];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(@"Unable to load history");
        }];
    
    [operation start];
}


@end
