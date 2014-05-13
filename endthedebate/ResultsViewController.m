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

@interface ResultsViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionview;
@property (nonatomic, strong) IBOutlet XYPieChart *pieChart;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;

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
    
    // Apply shadowing for the shareButton
    self.shareButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shareButton.layer.shadowOffset = CGSizeMake(0, 3.0f);
    self.shareButton.layer.shadowOpacity = 0.5f;
    
    // hide the navigation bar and back button
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;

    // Set up the pie chart to be displayed
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setAnimationSpeed:1.0];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    [self.pieChart setShowLabel:YES];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]]; //optional
    
    // Set up the colors to be used in the different slices of the pie chart.
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    // Set up the UINib to be used in the legend of the graph and register it
    UINib *nib = [UINib nibWithNibName:kLegendCell bundle:nil];
    [self.collectionview registerNib:nib forCellWithReuseIdentifier:kLegendCell];
}

- (void)viewDidAppear:(BOOL)animated
{
    // reload the data whenever the view appears
    [self.pieChart reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unhide the navigation bar when you leave the screen
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XYPieChart Data Source

/**
 Return the number of slices in the pie chart
 */
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [self.answers count];
}

/**
 Give the value for the slice at the given index (similar to UITableView). This
 will determine the size of the slice as a percentage of all of the slice's values.
 */
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    Answer *answer = [self.answers objectAtIndex:index];
    return answer.count;
}

/**
 Return the color for the slice at the given index
 */
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:index];
}

/**
 Supply the text for the slice at the given index (do not thinik this method works)
 */
- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    Answer *answer = [self.answers objectAtIndex:index];
    return answer.answer;
}

#pragma mark  - Button

/**
 Share the graph to Facebook by taking a screenshot of the view and
 converting it to a UIImage, then uploading it to Facebook
 */
- (IBAction)shareToFacebook:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        // Open up the Social View Controller for Facebook
        SLComposeViewController *social =
        [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        // Set a handler to be called once the view controller is finished uploading to FB
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result) {
            [social dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popToRootViewControllerAnimated:NO];
        };
        [social setCompletionHandler:completionHandler];
        
        // Take a screenshot of the graph
        UIImage *screenShot = [self screenShot];
        
        // add the image to be uploaded and present the view controller (part of iOS native library)
        [social addImage:screenShot];
        [self presentViewController:social animated:YES completion:nil];
    }
}

#pragma mark - UICollectionView Delegate

/**
 Return the number of sections for the legend that displays the corresponding colors for the
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/**
 Returns the number of items in the legend. This is basically the number of answers for the question.
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.answers count];
}

/**
 Set up the legend for each answer by giving the answer's text and the corresponding color for that answer based
 on the answer's index in the array
 */
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Answer *answer = [self.answers objectAtIndex:[indexPath row]];
    
    LegendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLegendCell forIndexPath:indexPath];
    cell.answerLabel.text = answer.answer;
    cell.colorView.backgroundColor = [self.sliceColors objectAtIndex:[indexPath row]];
    
    return cell;
}

#pragma mark - Helper

/**
 Take a screenshot of the graph
 */
- (UIImage*)screenShot
{
    CGRect frame = self.view.frame;
    frame.size.height = self.pieChart.frame.size.height + self.pieChart.frame.origin.y + 20;
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}

@end
