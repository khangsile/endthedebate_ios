//
//  ResultsViewController.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "ResultsViewController.h"

#import <Social/Social.h>

#import "Answer.h"
#import "LegendCell.h"

#define kLegendCell @"LegendCell"

@interface ResultsViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionview;
@property (nonatomic, strong) IBOutlet XYPieChart *pieChart;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) NSArray *sliceColors;

@end

@implementation ResultsViewController

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

    self.questionLabel.text = self.question.question;
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;

    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setAnimationSpeed:1.0];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    [self.pieChart setShowLabel:YES];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];	//optional

    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    UINib *nib = [UINib nibWithNibName:kLegendCell bundle:nil];
    [self.collectionview registerNib:nib forCellWithReuseIdentifier:kLegendCell];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChart reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [self.answers count];
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    Answer *answer = [self.answers objectAtIndex:index];
    return answer.count;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:index];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    Answer *answer = [self.answers objectAtIndex:index];
    return answer.answer;
}

#pragma mark  - Button Click

- (IBAction)toHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)shareToFacebook:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *social =
        [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result) {
            [social dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popToRootViewControllerAnimated:NO];
        };
        [social setCompletionHandler:completionHandler];
        
        UIImage *screenShot = [self screenShot];
        
        
        [social addImage:screenShot];
        [self presentViewController:social animated:YES completion:nil];
    }
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.answers count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Answer *answer = [self.answers objectAtIndex:[indexPath row]];
    
    LegendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLegendCell forIndexPath:indexPath];
    cell.answerLabel.text = answer.answer;
    cell.colorView.backgroundColor = [self.sliceColors objectAtIndex:[indexPath row]];
    
    return cell;
}

#pragma mark - Helper

- (UIImage*)screenShot
{
    CGRect frame = self.view.frame;
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}

@end
