//
//  TPPParsedPerson.h
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPPParsedPerson : NSObject

@property (strong, nonatomic) NSString *personID;
@property (strong, nonatomic) NSNumber *active;
@property (strong, nonatomic) NSString *pictureURL;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *registered;

+ (TPPParsedPerson *)parsedPersonWithDictionary:(NSDictionary *)dictionary;

@end
