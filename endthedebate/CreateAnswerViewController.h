//
//  CreateAnswerViewController.h
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Question.h"

@interface CreateAnswerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

- (id)initWithQuestion:(Question*)question;

@end
