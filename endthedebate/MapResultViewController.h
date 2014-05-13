//
//  MapResultViewController.h
//  endthedebate
//
//  Created by Khang Le on 1/4/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Question.h"

/**
 A UIViewController to hold the results of the question in a map format
 */
@interface MapResultViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

/**
 Initialize the UIViewController with an array of the answers and the question to be displayed
 @aparam answers An NSMutableArray of answers of the question to be displayed
 @param question The question to be displayed
 */
- (id)initWithArray:(NSMutableArray*)answers forQuestion:(Question*)question;

@end
