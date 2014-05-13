//
//  BarResultViewController.m
//  endthedebate
//
//  Created by Khang Le on 1/28/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import "BarResultViewController.h"

#define BAR_POSITION @"POSITION"
#define BAR_HEIGHT @"HEIGHT"
#define COLOR @"COLOR"
#define CATEGORY @"CATEGORY"

#define AXIS_START 0
#define AXIS_END 50

@interface BarResultViewController ()

@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) Question *question;

@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) CPTXYGraph *graph;

@property (nonatomic, strong) NSArray *colors;

@end

@implementation BarResultViewController

@synthesize graph;
@synthesize hostingView;

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
    
    // Initialize the colors for the bar graph into a NSArray
    self.colors = @[ [UIColor redColor],
        [UIColor blueColor],
        [UIColor orangeColor],
        [UIColor purpleColor]];
    
    // Generate the bar graph.
    [self generateBarPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarGraph Data Source

/**
 Supply the number of records for the plot to be generated (the number of answers)
*/
 -(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.answers count];
}

/**
 Supply the number for the given record in the plot (based on index). This is just the y-value
 of the record to determine how high the bar is set in the plot.
 */
-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    Answer *answer = [self.answers objectAtIndex:index];
    if(fieldEnum == CPTBarPlotFieldBarLocation)
        return [NSNumber numberWithInteger:index*15];
    else if(fieldEnum ==CPTBarPlotFieldBarTip)
        return [NSNumber numberWithInteger:[answer count]];
    
    return 0;
}

/**
 Supply the color for the record at the given index
 */
-(CPTFill*)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index
{
    
    CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor whiteColor]
                                                        endingColor:[self.colors objectAtIndex:index] // Set color here
                                                    beginningPosition:0.0 endingPosition:0.3];
    [gradient setGradientType:CPTGradientTypeAxial];
    [gradient setAngle:320.0];
        
    CPTFill *fill = [CPTFill fillWithGradient:gradient];
        
    return fill;
    
}

/**
 Set the label for the given record in the plot. This is just the text of the answer.
 */
-(CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    // Set the text style for the label
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 6;
    textStyle.color = [CPTColor whiteColor];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    // Set the text to be displayed for the given record
    Answer *answer = [self.answers objectAtIndex:index];
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:answer.answer];
    [label setMaximumSize:CGSizeMake(35.0, 1000)];
    label.textStyle =textStyle;
    
    return label;
}

#pragma mark - CPTBarPlotDelegate methods

/**
 Event called when a specific bar/record was selected
 */
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    //Do nothing
}

#pragma mark - Create CPTBarPlot

/**
 Generate the bar graph (taken from the example plot on Github)
 */
- (void)generateBarPlot
{
    //Create host view
    self.hostingView = [[CPTGraphHostingView alloc]
                        initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.view addSubview:self.hostingView];
    
    //Create graph and set it as host view's graph
    self.graph = [[CPTXYGraph alloc] initWithFrame:self.hostingView.bounds];
    [self.hostingView setHostedGraph:self.graph];
    
    //set graph padding and theme
    self.graph.plotAreaFrame.paddingTop = 20.0f;
    self.graph.plotAreaFrame.paddingRight = 20.0f;
    self.graph.plotAreaFrame.paddingBottom = 70.0f;
    self.graph.plotAreaFrame.paddingLeft = 70.0f;
    [self.graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    
    //set axes ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(0.0)
                                                    length:CPTDecimalFromFloat(5+50)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:
                        CPTDecimalFromFloat(AXIS_START)
                                                    length:CPTDecimalFromFloat(self.question.votesCount)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    //set axes' title, labels and their text styles
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 12;
    textStyle.color = [CPTColor whiteColor];
    axisSet.xAxis.title = @"Vote Category";
    axisSet.yAxis.title = @"# of Votes";
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.yAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = 30.0f;
    axisSet.yAxis.titleOffset = 40.0f;
    axisSet.yAxis.labelTextStyle = textStyle;
    axisSet.yAxis.labelOffset = 3.0f;
    //set axes' line styles and interval ticks
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor whiteColor];
    lineStyle.lineWidth = 3.0f;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.majorTickLineStyle = nil;
    axisSet.xAxis.minorTickLineStyle = nil;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(5.0f);
    axisSet.yAxis.majorTickLength = self.question.votesCount/5.0f;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTicksPerInterval = 1;
    axisSet.yAxis.minorTickLength = self.question.votesCount/5.0f/2;
    
    // Create bar plot and add it to the graph
    CPTBarPlot *plot = [[CPTBarPlot alloc] init];
    plot.dataSource = self;
    plot.delegate = self;
    plot.barWidth = [[NSDecimalNumber decimalNumberWithString:@"8.0"]
                     decimalValue];
    plot.barOffset = [[NSDecimalNumber decimalNumberWithString:@"5.0"]
                      decimalValue];
    plot.barCornerRadius = 5.0;
    // Remove bar outlines
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor clearColor];
    plot.lineStyle = borderLineStyle;
    // Identifiers are handy if you want multiple plots in one graph
    [self.graph addPlot:plot];
}

@end
