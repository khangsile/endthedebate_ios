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

@interface ResultsPageViewController ()

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
    
    [self addChildViewController:[[MapResultViewController alloc] initWithArray:self.answers
                                                                    forQuestion:self.question]];
    [self addChildViewController:[[ResultsViewController alloc] initWithArray:self.answers
                                                                  forQuestion:self.question]];
    self.sizes = @[[NSNumber numberWithFloat:453.0], [NSNumber numberWithFloat:500.0]];
    
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
        [self.scrollview addSubview:controller.view];
        CGRect frame = controller.view.frame;
        frame.origin.x = 0;
        frame.origin.y = totalSize;
        frame.size.height = ((NSNumber*)[self.sizes objectAtIndex:index]).floatValue;
        controller.view.frame = frame;
        totalSize += ((NSNumber*)[self.sizes objectAtIndex:index]).floatValue;
        index++;
    }
    
    self.scrollview.contentSize = CGSizeMake(self.scrollview.contentSize.width, totalSize);
}

@end
