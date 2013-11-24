//
//  QuestionPage.m
//  endthedebate
//
//  Created by Cody Hughes on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "QuestionViewController.h"

#import "Answer.h"

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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Answer *answer = [self.question.answers objectAtIndex:[indexPath row]];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    NSString *path = [NSString stringWithFormat:@"questions/%d/answers/%d/votes.json", self.question.questionId, answer.answerId];
    
    [manager postObject:nil path:path parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    [self.navigationController popToRootViewControllerAnimated:NO];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Something went wrong");
    }];
}

@end
