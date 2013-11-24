//
//  User.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "User.h"

@implementation User

static User *activeUser;

+ (RKObjectMapping*)getObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id" : @"userId",
        @"authentication_token" : @"authToken",
        @"first_name" : @"firstName",
        @"last_name" : @"lastName",
        @"city" : @"city",
        @"state" : @"state",
        @"email" : @"email"
    }];
    
    return mapping;
}

+ (RKResponseDescriptor*)getResponseMapping
{
    return [RKResponseDescriptor responseDescriptorWithMapping:[self getObjectMapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"user"
                                            statusCodes:nil];
}

+ (RKRequestDescriptor*)getRequestMapping
{
    return [RKRequestDescriptor requestDescriptorWithMapping:[self getObjectMapping]
                                          objectClass:[self class]
                                          rootKeyPath:nil
                                               method:RKRequestMethodAny];
    
}

+ (void)setActiveUser:(User*)user
{
    activeUser = user;
}

+ (User*)activeUser
{
    if (!activeUser)
        activeUser = [User new];
    
    return activeUser;
}

+ (void)login:(NSString*)authToken success:(void(^)(User *activeUser))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    NSMutableURLRequest *request = [manager requestWithObject:nil
                                                       method:RKRequestMethodPOST
                                                         path:@"facebook_login.json"
                                                   parameters:nil];
    [request setValue:authToken forHTTPHeaderField:@"OAUTH"];
    
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"%@", [operation HTTPRequestOperation].responseString);
            
            User *user = [mappingResult firstObject];
            [User setActiveUser:user];
            
            success(user);
        } failure:failure];
    
    [operation start];
}

@end
