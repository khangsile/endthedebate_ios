//
//  QuestionCell.m
//  endthedebate
//
//  Created by Khang Le on 11/24/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

@synthesize requiredCellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(243.0f, CGFLOAT_MAX);
    CGSize requiredSize = [self.questionLabel sizeThatFits:maxSize];
    self.questionLabel.frame = CGRectMake(self.questionLabel.frame.origin.x,
                                          self.questionLabel.frame.origin.y,
                                          requiredSize.width, requiredSize.height);
    
    self.requiredCellHeight = 11.0f + 11.0f;
    self.requiredCellHeight += self.questionLabel.frame.size.height;
}

- (void)setCellToSize:(CGSize)size
{
    CGFloat difference = size.height - self.questionLabel.frame.size.height;
    
    CGRect frame = self.questionLabel.frame;
    frame.size = size;
    self.questionLabel.frame = frame;
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height += difference;
    //self.frame = cellFrame;
}

- (void)sizeToFitQuestionLabel
{
    [self.questionLabel sizeToFit];
}

@end
