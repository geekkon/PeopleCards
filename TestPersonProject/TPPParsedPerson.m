//
//  TPPParsedPerson.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPParsedPerson.h"

@implementation TPPParsedPerson

+ (TPPParsedPerson *)parsedPersonWithDictionary:(NSDictionary *)dictionary {
    
    TPPParsedPerson *parsedPerson = [[TPPParsedPerson alloc] init];
    
    parsedPerson.personID = dictionary[@"_id"];
    parsedPerson.active = [dictionary[@"isActive"] boolValue];
    parsedPerson.pictureURL = dictionary[@"picture"];
    parsedPerson.age = [dictionary[@"age"] integerValue];
    parsedPerson.name = dictionary[@"name"];
    parsedPerson.gender = dictionary[@"gender"];
    parsedPerson.email = dictionary[@"email"];
    parsedPerson.phone = dictionary[@"phone"];
    parsedPerson.address = dictionary[@"address"];
    parsedPerson.registered = dictionary[@"registered"];
    
    NSLog(@"%@ %@", parsedPerson.name, parsedPerson.pictureURL);

    
    return parsedPerson;
}

@end
