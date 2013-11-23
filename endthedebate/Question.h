//
//  Question.h
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Question : NSObject

@property (nonatomic) NSUInteger qId;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSMutableArray *answers;

+ (RKObjectMapping*)getObjectMapping;
+ (RKResponseDescriptor*)getResponseMapping;
+ (RKRequestDescriptor*)getRequestMapping;

@end
