//
//  User.m
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import "User.h"

@implementation User

+ (RKObjectMapping*)getObjectMapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{
        @"id" : @"userId",
        @"first_name" : @"first_name",
        @"last_name" : @"last_name",
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
