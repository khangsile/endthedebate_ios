//
//  QuestionPage.h
//  endthedebate
//
//  Created by Cody Hughes on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "Question.h"

@interface QuestionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithQuestion:(Question*)question;

@end