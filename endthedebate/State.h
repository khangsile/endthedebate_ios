//
//  State.h
//  endthedebate
//
//  Created by Khang Le on 1/4/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RestKit/RestKit.h>

@interface State : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *answers;

+ (RKObjectMapping*)getMapping;

@end

@class StateAnswer;

@interface StateAnswer : NSObject

@property (nonatomic) NSUInteger answerId;
@property (nonatomic) NSUInteger voteCount;

+ (RKObjectMapping*)getMapping;

@end
