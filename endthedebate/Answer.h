//
//  Answer.h
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Answer : NSObject

@property (nonatomic) NSUInteger answerId;
@property (nonatomic) NSUInteger count;
@property (nonatomic, strong) NSString *answer;

+ (RKObjectMapping*)getObjectMapping;
+ (RKResponseDescriptor*)getResponseMapping;

@end
