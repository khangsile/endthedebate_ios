//
//  HistoryViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/24/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "HistoryViewController.h"

#import "QuestionViewController.h"
#import "ResultsViewController.h"

#import "Question.h"
#import "User.h"

#import "QuestionCell.h"

#define kQuestionCell @"QuestionCell"

@interface HistoryViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableview;

@property (nonatomic, strong) QuestionCell *offscreenCell;

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
    
    [self.offscreenCell.questionLabel setText:question.question];
    [self.offscreenCell layoutSubviews];
    return MAX(self.offscreenCell.requiredCellHeight, kQuestionCellHeight);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCell *cell = (QuestionCell*)[tableView dequeueReusableCellWithIdentifier:kQuestionCell forIndexPath:indexPath];
    Question *question = [self.questions objectAtIndex:[indexPath row]];
    cell.questionLabel.text = question.question;
    
    cell.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.questionLabel.numberOfLines = 0;
    
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
            ResultsViewController *resultsController = [[ResultsViewController alloc] initWithArray:question.answers forQuestion:question];
            [self.navigationController pushViewController:resultsController animated:YES];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Something is going wrong on MainViewController");
        NSLog(@"%@", operation.HTTPRequestOperation.responseString);
    }];
}

#pragma mark - Helper

- (void)loadQuestions
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    User *user = [User activeUser];
    
    NSString *path = [NSString stringWithFormat:@"users/%d/questions.json", user.userId];
    
    NSMutableURLRequest *request = [manager requestWithObject:nil
                                                       method:RKRequestMethodGET
                                                         path:path
                                                   parameters:nil];
    [request setValue:user.authToken forHTTPHeaderField:@"X-AUTH-TOKEN"];
    
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
