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

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic) NSUInteger userId;


+ (RKObjectMapping*)getObjectMapping;
+ (RKRequestDescriptor*)getRequestMapping;
+ (RKResponseDescriptor*)getResponseMapping;
+ (void)setActiveUser:(User*)user;
+ (User*)activeUser;
+ (void)login:(NSString*)authToken success:(void(^)(User *activeUser))success
      failure:(void(^)(RKObjectRequestOperation *operation, NSError *error))failure;
@end
