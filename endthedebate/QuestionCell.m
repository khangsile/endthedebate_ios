//
//  QuestionCell.m
//  endthedebate
//
//  Created by Khang Le on 11/24/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

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

- (void)setCellToSize:(CGSize)size
{
    CGFloat difference = size.height - self.questionLabel.frame.size.height;
    
    CGRect frame = self.questionLabel.frame;
    frame.size  = size;
    self.questionLabel.frame = frame;
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height += difference;
    //self.frame = cellFrame;
}

@end
