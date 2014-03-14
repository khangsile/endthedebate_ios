//
//  ResultsPageViewController.m
//  endthedebate
//
//  Created by Khang Le on 1/5/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import "ResultsPageViewController.h"

#import "MapResultViewController.h"
#import "ResultsViewController.h"
#import "BarResultViewController.h"

@interface ResultsPageViewController ()

@property (nonatomic, strong) IBOutlet UIView *questionView;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollview;

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) NSArray *sizes;

@end

@implementation ResultsPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithArray:(NSMutableArray *)answers forQuestion:(Question *)question
{
    if (self = [self init]) {
        self.answers = answers;
        self.question = question;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Shadow set up
    self.questionView.layer.shadowOffset = CGSizeMake(0, 5);
    self.questionView.layer.shadowOpacity = 0.75f;
    self.questionView.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    self.questionLabel.text = self.question.question;
    
    [self addChildViewController:[[MapResultViewController alloc] initWithArray:self.question.answers
                                                                    forQuestion:self.question]];
    [self addChildViewController:[[ResultsViewController alloc] initWithArray:self.question.answers
                                                                  forQuestion:self.question]];
    [self addChildViewController:[[BarResultViewController alloc] initWithArray:self.question.answers
                                                                    forQuestion:self.question]];
    self.sizes = @[[NSNumber numberWithFloat:430.0], [NSNumber numberWithFloat:500.0],
                   [NSNumber numberWithFloat:548.0]];
    
    [self addViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addViews
{
    NSUInteger index = 0;
    NSUInteger totalSize = 0;
    
    for (UIViewController *controller in self.childViewControllers) {
        [self.scrollview insertSubview:controller.view atIndex:1]; //add to the bottom of the stack
        
        CGRect frame = controller.view.frame;
        frame.origin.x = 0;
        frame.origin.y = totalSize;
        frame.size.height = ((NSNumber*)[self.sizes objectAtIndex:index]).floatValue;
        
        controller.view.frame = frame;
        controller.view.layer.shadowOpacity = .75f;
        controller.view.layer.shadowOffset = CGSizeMake(0, 3);
        controller.view.layer.shadowColor = [[UIColor blackColor] CGColor];
        
        totalSize += ((NSNumber*)[self.sizes objectAtIndex:index]).floatValue;
        index++;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, totalSize, 320.0f, 100.0f)];
    [view setBackgroundColor:[UIColor yellowColor]];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    exitButton.frame = CGRectMake(20.0f, 30.0f, 280.0f, 40.0f);
    [exitButton setBackgroundColor:[UIColor colorWithRed:225.0/256 green:222.0/256 blue:222.0/256 alpha:1.0f]];
    [exitButton setTitle:@"Find More Questions" forState:UIControlStateNormal];
    exitButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    exitButton.layer.shadowOffset = CGSizeMake(0, 3.0f);
    exitButton.layer.shadowOpacity = 0.5f;
    [exitButton addTarget:self action:@selector(toHome:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:exitButton];
    totalSize += 120;
    [self.scrollview insertSubview:view atIndex:1]; //add to the bottom of the stack
    
    self.scrollview.contentSize = CGSizeMake(self.scrollview.contentSize.width, totalSize);
}

#pragma mark - Button

- (IBAction)toHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
