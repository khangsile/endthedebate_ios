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

/*
 Singleton variable to hold the currently active user.
 */
static User *activeUser;

+ (User*)map:(id)data
{
    // Create an empty user class
    User* user = [[User alloc] init];
    
    NSLog(@"%@", data); // logging
    // Map the data (in json format) to a destination object (user) using the User object mapping.
    RKMappingOperation *mapper = [[RKMappingOperation alloc] initWithSourceObject:data
                                                                destinationObject:user
                                                                          mapping:[User getObjectMapping]];
    //RKMappingOperation will not run w/o a data source set
    RKObjectMappingOperationDataSource *mappingDS = [RKObjectMappingOperationDataSource new];
    mapper.dataSource = mappingDS; // set the data source for mapping it over
    [mapper performMapping:nil]; // perform the operation which will map the data into the user variable
    
    return user;
}

+ (RKObjectMapping*)getObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[User class]];
    // Create the mapping using a dictionary where the key is the json key while the value is name of the class's variable
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
    if (!activeUser) // ensure the active user is defined
        activeUser = [User new];
    
    return activeUser;
}

+ (void)login:(NSString*)authToken success:(void(^)(User *activeUser))success failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    // Get the object manager
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    // create a mutable url request
    NSMutableURLRequest *request = [manager requestWithObject:nil
                                                       method:RKRequestMethodPOST
                                                         path:@"facebook_login.json"
                                                   parameters:nil];
    // set the headers
    [request setValue:authToken forHTTPHeaderField:@"OAUTH"];
    
    // perform the operation to the network
    RKObjectRequestOperation *operation = [manager objectRequestOperationWithRequest:request
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"%@", [operation HTTPRequestOperation].responseString);
            
            NSError* error;
            // Convert the response data to an NSDictionary
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:[operation HTTPRequestOperation].responseData
                                                                 options:kNilOptions
                                                                   error:&error];
            // map the NSDictionary into a User object (the active user) and set the singleton activeUser
            activeUser = [User map:json];
            
            success(activeUser);
        } failure:failure];
    
    [operation start];
}

@end
