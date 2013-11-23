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

@property (nonatomic) NSUInteger userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;

+ (RKObjectMapping*)getObjectMapping;
+ (RKRequestDescriptor*)getRequestMapping;
+ (RKResponseDescriptor*)getResponseMapping;

@end
