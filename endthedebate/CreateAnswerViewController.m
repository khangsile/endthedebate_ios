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
#import "KLKeyBoardbar.h"

#import <CoreGraphics/CoreGraphics.h>

#define kAnswerCell @"AnswerCell"

@interface CreateAnswerViewController ()

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSMutableArray *answers;

@property (nonatomic, strong) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) IBOutlet UILabel *answerLabel;
@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UITextField *answerField;
@property (nonatomic, strong) IBOutlet KLKeyboardBar *keyboardBar;

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
    
    self.keyboardBar.resizeViews = [NSMutableArray arrayWithArray:@[self.tableview]];
    
    self.answerLabel.text = [self.question question];
    
    self.submitButton.layer.cornerRadius = 5.0f;
    self.submitButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.submitButton.layer.borderWidth = 1.0f;
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
    cell.contentView.backgroundColor = [UIColor colorWithRed:49/255.0 green:224/255.0 blue:236/255.0 alpha:.5];
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
    
    if ([self.answers count] == 0) return;
    
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
