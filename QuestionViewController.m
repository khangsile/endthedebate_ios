//
//  QuestionPage.m
//  endthedebate
//
//  Created by Cody Hughes on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "QuestionViewController.h"

#import "ResultsPageViewController.h"

#import "Answer.h"
#import "User.h"

#import "AnswerCell.h"

#define kAnswerCell @"AnswerCell"

@interface QuestionViewController()

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;

@property (nonatomic, strong) Question *question;

@end

@implementation QuestionViewController

- (id)initWithQuestion:(Question*)question
{
    if (self=[self init]) {
        self.question = question;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:kAnswerCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:kAnswerCell];
    
    self.questionLabel.text = [self.question question];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.question.answers count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCell *cell = (AnswerCell*)[tableView dequeueReusableCellWithIdentifier:kAnswerCell forIndexPath:indexPath];
    
    cell.letter.text = [NSString stringWithFormat:@"%c", [indexPath row]+65];
    
    Answer *answer = [self.question.answers objectAtIndex:[indexPath row]];
    cell.answerLabel.text = answer.answer;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:255/255.0 alpha:.5];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Answer *answer = [self.question.answers objectAtIndex:[indexPath row]];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"questions/%d/answers/%d/votes.json", self.question.questionId, answer.answerId];
    
    NSMutableURLRequest *request = [manager requestWithObject:nil method:RKRequestMethodPOST path:path parameters:nil];
    [request setValue:[[User activeUser] authToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [request setValue:[[User activeUser] email] forHTTPHeaderField:@"X-USER-EMAIL"];
    
    [[manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", operation.HTTPRequestOperation.responseString);
        NSMutableArray *answers = [NSMutableArray arrayWithArray:[mappingResult array]];
        
        [self.navigationController pushViewController:[[ResultsPageViewController alloc] initWithArray:answers forQuestion:self.question] animated:YES];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.HTTPRequestOperation.responseString);
        NSLog(@"Something went wrong");
    }] start];
    
}

@end
