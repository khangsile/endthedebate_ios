//
//  Question.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "Question.h"
#import "Answer.h"

@implementation Question

+ (RKObjectMapping*)getObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id" : @"questionId",
        @"question" : @"question"
    }];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answers"
                                                                           toKeyPath:@"answers"
                                                                         withMapping:[Answer getObjectMapping]]];
    
    return mapping;
}

+ (RKResponseDescriptor*)getResponseMapping
{
    return [RKResponseDescriptor responseDescriptorWithMapping:[self getObjectMapping]
                                                        method:RKRequestMethodAny
                                                   pathPattern:nil
                                                       keyPath:nil
                                                   statusCodes:nil];
}

+ (RKRequestDescriptor*)getRequestMapping
{
    return [RKRequestDescriptor requestDescriptorWithMapping:[self getObjectMapping]
                                                 objectClass:[self class]
                                                 rootKeyPath:nil
                                                      method:RKRequestMethodAny];
}

@end
