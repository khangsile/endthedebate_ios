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
    // Do any additional setup after loading the view from its nib.
    self.colors = @[ [UIColor redColor],
        [UIColor blueColor],
        [UIColor orangeColor],
        [UIColor purpleColor]];
    
    [self generateBarPlot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarGraph Data Source

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.answers count];
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    Answer *answer = [self.answers objectAtIndex:index];
    if(fieldEnum == CPTBarPlotFieldBarLocation)
        return [NSNumber numberWithInteger:index*15];
    else if(fieldEnum ==CPTBarPlotFieldBarTip)
        return [NSNumber numberWithInteger:[answer count]];
    
    return 0;
}

-(CPTFill*)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index
{
    
    CPTGradient *gradient = [CPTGradient gradientWithBeginningColor:[CPTColor whiteColor]
                                                        endingColor:[self.colors objectAtIndex:index]
                                                    beginningPosition:0.0 endingPosition:0.3];
    [gradient setGradientType:CPTGradientTypeAxial];
    [gradient setAngle:320.0];
        
    CPTFill *fill = [CPTFill fillWithGradient:gradient];
        
    return fill;
    
}

-(CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 6;
    textStyle.color = [CPTColor whiteColor];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    Answer *answer = [self.answers objectAtIndex:index];
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:answer.answer];
    [label setMaximumSize:CGSizeMake(35.0, 1000)];
    label.textStyle =textStyle;
    
    return label;
}

#pragma mark - CPTBarPlotDelegate methods

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    //Do nothing
}

#pragma mark - Create CPTBarPlot

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
