//
//  MapResultViewController.m
//  endthedebate
//
//  Created by Khang Le on 1/4/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import "MapResultViewController.h"

#import <USStatesColorMap/USStatesColorMap.h>
#import <Social/Social.h>

#import "Answer.h"
#import "State.h"

#import "LegendCell.h"

@interface MapResultViewController ()

@property (nonatomic, strong) IBOutlet USStatesColorMap *map;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionview;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) NSArray *sliceColors;

@end

@implementation MapResultViewController

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
    
    // Set the shadow for the layering
    self.shareButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shareButton.layer.shadowOffset = CGSizeMake(0, 3.0f);
    self.shareButton.layer.shadowOpacity = 0.5f;
    
    // Hide the navigation bar
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
    
    // Set the colors to be used in the map that correspond to each answer
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    // Set the UINib for the cell to be used in the legend
    UINib *nib = [UINib nibWithNibName:kLegendCell bundle:nil];
    [self.collectionview registerNib:nib forCellWithReuseIdentifier:kLegendCell];
    [self loadMap];
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

#pragma mark - UICollectionView Delegate

/**
 Return the number of sections in the legend (default to 1)
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/**
 Return the number of items in the legend. This is just the number of answers.
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.answers count];
}

/**
 Create a cell in the legend to represent each answer by displaying its text and corresponding color
 */
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the answer
    Answer *answer = [[self.question answers] objectAtIndex:[indexPath row]];
    
    LegendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLegendCell forIndexPath:indexPath];
    cell.answerLabel.text = answer.answer; // set the text of the answer
    // set the color that corresponds to the answer
    cell.colorView.backgroundColor = [self.sliceColors objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark - Colorable Map

/**
 Load the map
 */
- (void)loadMap
{
    // Default all states to gray, so states that have not voted are gray.
    [self.map setColorForAllStates:[UIColor lightGrayColor]];
    for (State *state in self.question.mapAnswers) {
        NSUInteger maxNum = 0, maxId = 0;
        // Get the answer with the most votes per state
        for (StateAnswer *answer in state.answers) {
            if ([answer voteCount] > maxNum) {
                maxNum = [answer voteCount];
                maxId = [answer answerId];
            }
        }
        // Set the color of the state based on the answer with the most votes
        for (int i=0; i<[self.question.answers count]; i++) {
            Answer *answer = [self.question.answers objectAtIndex:i];
            if (maxId == answer.answerId) {
                if (![state.name isEqualToString:@""])
                    [self.map setColor:[self.sliceColors objectAtIndex:i] forStateByName:state.name];
                break;
            }
        }
    }
    
}

#pragma mark - Button

/**
 Share the graph to Facebook by taking a screenshot of the view and
 converting it to a UIImage, then uploading it to Facebook
 */
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

#pragma mark - Helper

/**
 Take a screenshot of the graph
 */
- (UIImage*)screenShot
{
    CGRect frame = self.view.frame;
    frame.size.height = self.map.frame.size.height + self.map.frame.origin.y + 20;
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}





@end
