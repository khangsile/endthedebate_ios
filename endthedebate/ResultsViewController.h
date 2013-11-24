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

@interface ResultsViewController : UIViewController <XYPieChartDataSource, XYPieChartDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

- (id)initWithArray:(NSMutableArray*)answers forQuestion:(Question*)question;

@end
