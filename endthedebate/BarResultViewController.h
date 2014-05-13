//
//  BarResultViewController.h
//  endthedebate
//
//  Created by Khang Le on 1/28/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CorePlot-CocoaTouch.h>

#import "Question.h"
#import "Answer.h"

/**
 A UIViewController to hold the results of the question in a bar graph format
 */
@interface BarResultViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>

/**
 Initialize the UIViewController with an array of the answers and the question to be displayed
 @aparam answers An NSMutableArray of answers of the question to be displayed
 @param question The question to be displayed
 */
- (id)initWithArray:(NSMutableArray *)answers forQuestion:(Question *)question;

@end
