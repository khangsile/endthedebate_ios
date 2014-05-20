//
//  User.h
//  endthedebate
//
//  Created by Khang Le on 11/23/13.
//  Copyright (c) 2013 Khang Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface User : NSObject

/*
 The user's email
 */
@property (nonatomic, strong) NSString *email;
/*
 The user's authentication token (for OAuth)
 */
@property (nonatomic, strong) NSString *authToken;
/*
 The user's first name
 */
@property (nonatomic, strong) NSString *firstName;
/*
 The user's last name
 */
@property (nonatomic, strong) NSString *lastName;
/* 
 The user's current city
 */
@property (nonatomic, strong) NSString *city;
/*
 The user's current state of residence
 */
@property (nonatomic, strong) NSString *state;
/*
 The user's id
 */
@property (nonatomic) NSUInteger userId;

/****************************************** RESTKIT METHODS **********************************/

/**
 Get a RestKit object mapping of the user class
 @return a RestKit object mapping for the user class (maps json to user attributes)
 */
+ (RKObjectMapping*)getObjectMapping;
/**
 Get a RKRequestDescriptor mapping of the user class for deserializing objects to json
 @return an RKRequestDescriptor of the user class
 */
+ (RKRequestDescriptor*)getRequestMapping;
/**
 Get a RKResponseDescriptor mapping for the user class for serializing objects from json
 @return an RKResponseDescritpor of the user class
 */
+ (RKResponseDescriptor*)getResponseMapping;

/****************************************** USER STATIC METHODS *********************************************/

/** 
 Set the active user. This respresents the user that is currently logged into the app.
 @param user A user object that will be set to the active user
 */
+ (void)setActiveUser:(User*)user;
/**
 Get the active user. This represents the user that is currently logged into the app.
 @return a User object that represents the active user
 */
+ (User*)activeUser;
/**
 Sends an attempt to log into the application via an authentication token from Facebook
 @param authToken An NSString that represents the user's authentication token on Facebook
 @param success A code block with paramater (User) that will be called when the login is a success.
 @param failure A code block with no paramters that will be called when the login is a failure.
 */
+ (void)login:(NSString*)authToken success:(void(^)(User *activeUser))success
      failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;
@end
