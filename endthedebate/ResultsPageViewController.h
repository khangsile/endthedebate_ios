//
//  ResultsPageViewController.h
//  endthedebate
//
//  Created by Khang Le on 1/5/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Question.h"

@interface ResultsPageViewController : UIViewController

- (id)initWithArray:(NSMutableArray*)answers forQuestion:(Question*)question;

@end
