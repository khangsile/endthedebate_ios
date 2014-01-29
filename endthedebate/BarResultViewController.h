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

@interface BarResultViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>

- (id)initWithArray:(NSMutableArray *)answers forQuestion:(Question *)question;

@end
