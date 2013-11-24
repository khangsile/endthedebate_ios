//
//  Answer.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "Answer.h"

@implementation Answer

+ (RKObjectMapping*)getObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id" : @"answerId",
        @"name" : @"answer",
        @"count" : @"count"
    }];
    
    return mapping;
}

+ (RKResponseDescriptor*)getResponseMapping
{
    return [RKResponseDescriptor responseDescriptorWithMapping:[self getObjectMapping]
                                                        method:RKRequestMethodAny
                                                   pathPattern:nil
                                                       keyPath:@"answer"
                                                   statusCodes:nil];
}

@end
