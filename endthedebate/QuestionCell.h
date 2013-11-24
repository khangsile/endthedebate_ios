//
//  QuestionCell.h
//  endthedebate
//
//  Created by Khang Le on 11/24/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kQuestionCellHeight 44
#define kQuestionLabelWidth 280
#define kQuestionLabelHeight 21

@interface QuestionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *questionLabel;

- (void)setCellToSize:(CGSize)size;

@end
