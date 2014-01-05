//
//  State.m
//  endthedebate
//
//  Created by Khang Le on 1/4/14.
//  Copyright (c) 2014 Khang Le. All rights reserved.
//

#import "State.h"

@implementation State

+ (RKObjectMapping*)getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[State class]];
    mapping.forceCollectionMapping = YES;
    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"name"];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"(name)"
                                                                            toKeyPath:@"answers"
                                                                          withMapping:[StateAnswer getMapping]]];
    return mapping;
}

@end

@implementation StateAnswer

+ (RKObjectMapping*)getMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[StateAnswer class]];
    mapping.forceCollectionMapping = YES;
    [mapping addAttributeMappingFromKeyOfRepresentationToAttribute:@"answerId"];
    [mapping addAttributeMappingsFromDictionary:@{
        @"(answerId)":@"voteCount"
    }];
        
    return mapping;
}

@end
