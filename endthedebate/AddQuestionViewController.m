//
//  AddQuestionViewController.m
//  endthedebate
//
//  Created by Khang Le on 1/4/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import "AddQuestionViewController.h"

@interface AddQuestionViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UITextField *answerField;

@property (nonatomic, strong) NSMutableArray *answers;

@end

@implementation AddQuestionViewController

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
    return [self.questions count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == [self.questions count]) return 44;
    
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
    
    if ([self.questions count] - [indexPath row] < 3 && !self.isLoading && !self.isEmpty) {
        self.isLoading = YES;
        self.pageNo++;
        [self loadQuestions];
    }
    
    return cell;
}


@end
