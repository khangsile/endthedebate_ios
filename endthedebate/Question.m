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
        @"content" : @"question"
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
                                                       keyPath:@"question"
                                                   statusCodes:nil];
}

+ (RKRequestDescriptor*)getRequestMapping
{
    return [RKRequestDescriptor requestDescriptorWithMapping:[[self getObjectMapping] inverseMapping]
                                                 objectClass:[self class]
                                                 rootKeyPath:nil
                                                      method:RKRequestMethodAny];
}

+ (void)getQuestions:(NSInteger)page pageSize:(NSInteger)size success:(void(^)(NSMutableArray* questions))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    NSDictionary *dictionary = @{
                                 @"page" : [NSNumber numberWithInteger:page],
                                 @"per_page" : [NSNumber numberWithInteger:size]
                                };
    
    [manager getObject:nil path:@"questions.json" parameters:dictionary
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   success([[NSMutableArray alloc] initWithArray:[mappingResult array]]);
    } failure:failure];
}

- (id)init
{
    if (self = [super init]) {
        self.answers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
