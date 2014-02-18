//
//  Question.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "Question.h"
#import "Answer.h"
#import "State.h"

@implementation Question

+ (RKObjectMapping*)getObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id" : @"questionId",
        @"content" : @"question",
        @"answered" : @"answered",
        @"votes_count" : @"votesCount"
    }];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"answers"
                                                                           toKeyPath:@"answers"
                                                                         withMapping:[Answer getObjectMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"map"
                                                                            toKeyPath:@"mapAnswers"
                                                                          withMapping:[State getMapping]]];
    
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
    return [RKRequestDescriptor requestDescriptorWithMapping:[[self getObjectMapping] inverseMapping]
                                                 objectClass:[self class]
                                                 rootKeyPath:nil
                                                      method:RKRequestMethodAny];
}

+ (void)getQuestions:(NSInteger)page pageSize:(NSInteger)size sortBy:(NSString*)sortBy success:(void(^)(NSMutableArray* questions))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    NSDictionary *dictionary = @{
                                 @"page" : [NSNumber numberWithInteger:page],
                                 @"per_page" : [NSNumber numberWithInteger:size],
                                 @"sort_by" : sortBy
                                };
    
    [manager getObject:nil path:@"questions.json" parameters:dictionary
               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   NSLog(@"%@", operation.HTTPRequestOperation.responseString);
                   success([[NSMutableArray alloc] initWithArray:[mappingResult array]]);
    } failure:failure];
}

+ (void)getQuestion:(NSInteger)questionId forUser:(User*)user success:(void(^)(Question *question))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSString *path = [NSString stringWithFormat:@"questions/%d.json", questionId];
    
    NSMutableURLRequest *request = [manager requestWithObject:nil
                                                       method:RKRequestMethodGET
                                                         path:path
                                                   parameters:nil];
    [request setValue:user.authToken forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [request setValue:user.email forHTTPHeaderField:@"X-USER-EMAIL"];
    
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"%@", operation.HTTPRequestOperation.responseString);
            success([mappingResult firstObject]);
        } failure:failure];
    
    [operation start];
}

+ (void)search:(NSString*)query success:(void(^)(NSMutableArray *questions))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    NSString *path = @"search.json";
    NSDictionary *params = @{ @"query" : query };
    
    NSMutableURLRequest *request = [manager requestWithObject:nil
                                                       method:RKRequestMethodPOST
                                                         path:path
                                                   parameters:params];
    
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", operation.HTTPRequestOperation.responseString);
        success([[NSMutableArray alloc] initWithArray:[mappingResult array]]);
    } failure:failure];
    
    [operation start];
}

- (id)init
{
    if (self = [super init]) {
        self.answers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
