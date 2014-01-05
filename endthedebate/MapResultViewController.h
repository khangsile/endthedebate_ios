//
//  MapResultViewController.h
//  endthedebate
//
//  Created by Khang Le on 1/4/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Question.h"

@interface MapResultViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

- (id)initWithArray:(NSMutableArray*)answers forQuestion:(Question*)question;

@end
