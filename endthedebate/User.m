//
//  User.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "User.h"

//#import <RestKit/RKObjectMappingOperationDataSource.h>
#import <RestKit/ObjectMapping/RKObjectMappingOperationDataSource.h>

@implementation User

static User *activeUser;


+ (User*)map:(id)data
{
    User* user = [[User alloc] init];
    
    NSLog(@"%@", data);
    RKMappingOperation *mapper = [[RKMappingOperation alloc] initWithSourceObject:data //array of media
                                                                destinationObject:user  //collection view data source
                                                                          mapping:[User getObjectMapping]];
    //RKMappingOperation will not run w/o a data source set
    RKObjectMappingOperationDataSource *mappingDS = [RKObjectMappingOperationDataSource new];
    mapper.dataSource = mappingDS;
    [mapper performMapping:nil];
    
    return user;
}

+ (RKObjectMapping*)getObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"email" : @"email",
        @"authentication_token" : @"authToken",
        @"id" : @"userId",
        @"first_name" : @"firstName",
        @"last_name" : @"lastName",
        @"city" : @"city",
        @"state" : @"state",
    }];
    
    return mapping;
}

+ (RKResponseDescriptor*)getResponseMapping
{
    return [RKResponseDescriptor responseDescriptorWithMapping:[self getObjectMapping]
                                                 method:RKRequestMethodPOST
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
            
            NSError* error;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[operation HTTPRequestOperation].responseData
                                                                 options:kNilOptions
                                                                   error:&error];
            
            activeUser = [User map:json];
            
            success(activeUser);
        } failure:failure];
    
    [operation start];
}

@end
