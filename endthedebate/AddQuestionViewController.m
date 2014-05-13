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

/**
 A UITableView which holds the answers to the question
 */
@property (nonatomic, strong) IBOutlet UITableView *tableview;
/**
 A UITextField to hold the question being created
 */
@property (nonatomic, strong) IBOutlet UITextField *questionField;
/**
 A keyboardBar to react to the keyboard moving up on the screen
 */
@property (nonatomic, strong) IBOutlet KLKeyboardBar *keyboardBar;
/**
 A cell to add an answer. When clicked it adds another row in the tableview
 to insert an answer.
 */
@property (nonatomic, strong) AddAnswerCell *offscreenCell;
/**
 An NSMutableArray to hold the answers
 */
@property (nonatomic, strong) NSMutableArray *answers;
/**
 The number of answers
 */
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
    
    // Set the views to be resized when the keyboard pops up
    NSMutableArray *resizeViews = [[NSMutableArray alloc] initWithArray:@[self.tableview]];
    [self.keyboardBar setResizeViews:resizeViews];
    
    // Set up the cell types to be loaded into the tableview
    UINib *nib = [UINib nibWithNibName:kAddAnswerCell bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:kAddAnswerCell];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.offscreenCell = [self.tableview dequeueReusableCellWithIdentifier:kAddAnswerCell];
    
    // Set the outer border of the table view
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

/**
 Set the number of sections
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 Set the number of rows in the tableview. This should be the number of answers + the cell for the 
 button to generate another answer
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.answersCount + 1;
}

/**
 Create the cell to create an answer
 */
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
    // Set button to delete answer
    [cell.deleteButton addTarget:self action:@selector(removeAnswer:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

/**
 Delegate method to respond to when a cell has been pressed. This only reacts to when the "Add Answer" cell
 has been pressed.
 */
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

/**
 Remove the given answer and cell from the tableview
 */
- (void)removeAnswer:(id)sender
{
    NSIndexPath *indexPath = [self.tableview indexPathForCell:
                              (UITableViewCell*)([[[(UIView*)sender superview] superview] superview])];
    
    if (indexPath != nil) { // this means a cell has been chosen
        self.answersCount--; // decrease the number of answers
        
        // Get the given answer at the indexPath
        AddAnswerCell *cell = (AddAnswerCell*)[self.tableview cellForRowAtIndexPath:indexPath];
        [cell.answerField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged]; // remove all targets
        
        [self.answers removeObjectAtIndex:[indexPath row]]; // remove the answer from the array
        // delete the cell
        [self.tableview beginUpdates];
        [self.tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableview endUpdates];

        // create the updates to the tableview to reload the tableview
        NSMutableArray *updates = [NSMutableArray new];
        for(int i=[indexPath row]; i<self.answersCount; i++)
            [updates addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.tableview reloadRowsAtIndexPaths:updates withRowAnimation:UITableViewRowAnimationFade];

    }
}

/**
 Adjust the height of the tableview based on the number of answers
 */
- (void)adjustTableviewHeight
{
    CGRect frame = self.tableview.frame;
    frame.size.height = //((self.answersCount+1)*44.0f < 350.0f) ?
        (self.answersCount + 1) * 44.0f;
    [self.tableview setFrame:frame];
}

#pragma mark - UITextField Delegate

/**
 React to when a textfield (the questionField or answers' fields) are being updated (when user is typing).
 */
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

/**
 Upload the question to the server
 */
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
