//
//  CreateQuestionViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "CreateQuestionViewController.h"

#import "CreateAnswerViewController.h"

#import "Question.h"

@interface CreateQuestionViewController ()

@property (nonatomic, strong) Question *question;

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end

@implementation CreateQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.question = [Question new];
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

- (IBAction)submitQuestion:(id)sender
{
    [self.question setQuestion:[self.textField text]];
    [self.navigationController pushViewController:[[CreateAnswerViewController alloc] initWithQuestion:self.question] animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.textField) {
        [textField resignFirstResponder];
        
        [self submitQuestion:textField];
    }
    return NO;
}

@end
