//
//  ResultsViewController.h
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Question.h"

#import "XYPieChart.h"

/**
 A UIViewController that holds the results of the question in the format of a pie chart
 */
@interface ResultsViewController : UIViewController <XYPieChartDataSource, XYPieChartDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

/**
 Initialize the UIViewController with an array of the answers and the question to be displayed
 @aparam answers An NSMutableArray of answers of the question to be displayed
 @param question The question to be displayed
 */
- (id)initWithArray:(NSMutableArray*)answers forQuestion:(Question*)question;

@end
