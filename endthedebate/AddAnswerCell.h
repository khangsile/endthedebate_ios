//
//  AddAnswerCell.h
//  endthedebate
//
//  Created by Khang Le on 1/4/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAddAnswerCell @"AddAnswerCell"

@interface AddAnswerCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UITextField *answerField;
@property (nonatomic, strong) IBOutlet UILabel *answerLabel;
@property (nonatomic, strong) IBOutlet UIButton *deleteButton;

@end
