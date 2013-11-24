//
//  CreateAnswerViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "CreateAnswerViewController.h"

#import "Answer.h"

#import "AnswerCell.h"

#define kAnswerCell @"AnswerCell"

@interface CreateAnswerViewController ()

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSMutableArray *answers;

@property (nonatomic, strong) IBOutlet UILabel *answerLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UITextField *answerField;

@end

@implementation CreateAnswerViewController

- (id)init
{
    if (self = [super init]) {
        self.answers = [NSMutableArray new];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithQuestion:(Question *)question
{
    if (self = [self init]) {
        self.question = question;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINib *nib = [UINib nibWithNibName:kAnswerCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:kAnswerCell];
    
    self.answerLabel.text = [self.question question];
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
    return [self.answers count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerCell *cell = (AnswerCell*)[tableView dequeueReusableCellWithIdentifier:kAnswerCell forIndexPath:indexPath];
    
    cell.letter.text = [NSString stringWithFormat:@"%c", [indexPath row]+65];
    cell.answerLabel.text = [self.answers objectAtIndex:[indexPath row]];
    
    return cell;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.answerField) {
        [textField resignFirstResponder];
        
        [self addAnswer:textField];
    }
    
    return NO;
}

#pragma mark - Button Actions

- (IBAction)addAnswer:(id)sender
{
    [self.answers addObject:[self.answerField text]];
    [self.tableview reloadData];
    
    self.answerField.text = @"";
}

- (IBAction)postQuestion:(id)sender
{
    NSDictionary *params = @{
                             @"content" : self.question.question,
                             @"answers" : self.answers
                            };
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager postObject:nil path:@"questions.json" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Something went wrong");
    }];
}

@end