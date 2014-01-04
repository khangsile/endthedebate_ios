//
//  QuestionCell.h
//  endthedebate
//
//  Created by Khang Le on 11/24/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kQuestionCellHeight 44
#define kQuestionLabelWidth 243
#define kQuestionLabelHeight 13

@interface QuestionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic) float requiredCellHeight;

- (void)setCellToSize:(CGSize)size;
- (void)sizeToFitQuestionLabel;


@end
