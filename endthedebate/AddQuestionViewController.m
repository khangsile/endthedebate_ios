//
//  AddQuestionViewController.m
//  endthedebate
//
//  Created by Khang Le on 1/4/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import "AddQuestionViewController.h"

#import "AddAnswerCell.h"

#import "KLKeyBoardbar.h"
#import "User.h"

#import "Question.h"

#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>

@interface AddQuestionViewController ()

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UITextField *questionField;
@property (nonatomic, strong) IBOutlet KLKeyboardBar *keyboardBar;

@property (nonatomic, strong) AddAnswerCell *offscreenCell;

@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic) NSUInteger answersCount;

@end

@implementation AddQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.answersCount = 0;
        self.answers = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableArray *resizeViews = [[NSMutableArray alloc] initWithArray:@[self.tableview]];
    [self.keyboardBar setResizeViews:resizeViews];
    
    UINib *nib = [UINib nibWithNibName:kAddAnswerCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:kAddAnswerCell];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.offscreenCell = [self.tableview dequeueReusableCellWithIdentifier:kAddAnswerCell];
    
    self.tableview.layer.cornerRadius = 5.0f;
    self.tableview.layer.borderWidth = 1.0f;
    self.tableview.layer.borderColor = [[UIColor colorWithRed:225.0/256 green:222.0/256 blue:222.0/256 alpha:1.0] CGColor];
    //[self adjustTableviewHeight];
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
    return self.answersCount + 1;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == self.answersCount) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        [cell.textLabel setText:@"Add choice"];
        [cell setBackgroundColor:[UIColor colorWithRed:225.0/256 green:222.0/256 blue:222.0/256 alpha:1]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    AddAnswerCell *cell = (AddAnswerCell*)[tableView dequeueReusableCellWithIdentifier:kAddAnswerCell forIndexPath:indexPath];
    [cell.answerLabel setText:[NSString stringWithFormat:@"%c", [indexPath row]+65]];
    [cell.answerField setDelegate:self];
    [cell.answerField setText:[self.answers objectAtIndex:[indexPath row]]];
    [cell.answerField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.deleteButton addTarget:self action:@selector(removeAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == self.answersCount) {
        self.answersCount++;
        [self.answers addObject:@""];
        //[self adjustTableviewHeight];
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.answersCount-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
    }
}

- (void)removeAnswer:(id)sender
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:
                              (UITableViewCell*)([[[(UIView*)sender superview] superview] superview])];
    
    if (indexPath != nil) {
        self.answersCount--;
        
        AddAnswerCell *cell = (AddAnswerCell*)[self.tableview cellForRowAtIndexPath:indexPath];
        [cell.answerField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self.answers removeObjectAtIndex:[indexPath row]];
        [self.tableview beginUpdates];
        [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableview endUpdates];
        NSMutableArray *updates = [NSMutableArray new];
        for(int i=[indexPath row]; i<self.answersCount; i++)
            [updates addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.tableview reloadRowsAtIndexPaths:updates withRowAnimation:UITableViewRowAnimationFade];

    }
}

- (void)adjustTableviewHeight
{
    CGRect frame = self.tableview.frame;
    frame.size.height = //((self.answersCount+1)*44.0f < 350.0f) ?
        (self.answersCount + 1) * 44.0f;
    [self.tableview setFrame:frame];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:
                              (UITableViewCell*)([[[(UIView*)textField superview] superview] superview])];
    
    if (!indexPath && [[textField text] isEqualToString:@"What do you want to know?"]) {
        [textField setText:@""];
        return;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:
                              (UITableViewCell*)([[[(UIView*)textField superview] superview] superview])];
    
    if (!indexPath && [[textField text] isEqualToString:@""]) {
        [textField setText:@"What do you want to know?"];
        return;
    }
    
    if (indexPath) [self.answers replaceObjectAtIndex:[indexPath row] withObject:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidChange:(id)sender
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:
                              (UITableViewCell*)([[[(UIView*)sender superview] superview] superview])];
    if (indexPath) [self.answers replaceObjectAtIndex:[indexPath row] withObject:((UITextField*)sender).text];
}

#pragma mark - Submit Button Pressed

- (IBAction)uploadQuestion:(id)sender
{
    NSString *error = [Question uploadQuestion:self.questionField.text answers:self.answers user:[User activeUser] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failure to upload question: %@", operation.HTTPRequestOperation.responseString);
    }];
    
    if (![error isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Upload Error" message:error delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
    }
}


@end
