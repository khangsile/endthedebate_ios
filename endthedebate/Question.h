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

@property (nonatomic) NSUInteger questionId;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic) BOOL answered;

+ (RKObjectMapping*)getObjectMapping;
+ (RKResponseDescriptor*)getResponseMapping;
+ (RKRequestDescriptor*)getRequestMapping;
+ (void)getQuestions:(NSInteger)page pageSize:(NSInteger)size success:(void(^)(NSMutableArray* questions))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;
+ (void)getQuestion:(NSInteger)questionId forUser:(NSString*)authToken success:(void(^)(Question *question))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end
