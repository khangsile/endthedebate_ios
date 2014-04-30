//
//  Question.h
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "User.h"

@interface Question : NSObject

@property (nonatomic) NSUInteger questionId;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) NSMutableArray *mapAnswers;
@property (nonatomic) NSUInteger votesCount;
@property (nonatomic) BOOL answered;

+ (RKObjectMapping*)getObjectMapping;
+ (RKResponseDescriptor*)getResponseMapping;
+ (RKRequestDescriptor*)getRequestMapping;
+ (void)getQuestions:(NSInteger)page pageSize:(NSInteger)size sortBy:(NSString*)sortBy success:(void(^)(NSMutableArray* questions))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;
+ (void)getQuestion:(NSInteger)questionId forUser:(User*)user success:(void(^)(Question *question))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;
+ (void)search:(NSString*)query success:(void(^)(NSMutableArray *questions))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;
+ (NSString*)uploadQuestion:(NSString*)question answers:(NSMutableArray*)answers user:(User*)user
    success:(void(^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end
