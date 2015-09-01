//
//  TPPPerson.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPPerson.h"
#import "TPPParsedPerson.h"

@implementation TPPPerson

@dynamic personID;
@dynamic active;
@dynamic pictureURL;
@dynamic age;
@dynamic name;
@dynamic gender;
@dynamic email;
@dynamic phone;
@dynamic address;
@dynamic registered;

+ (void)createPersonWithParsedPerson:(TPPParsedPerson *)parsedPerson inContext:(NSManagedObjectContext *)context usingDateFormatter:(NSDateFormatter *)dateFormatter {
    
    TPPPerson *person = [NSEntityDescription insertNewObjectForEntityForName:@"TPPPerson" inManagedObjectContext:context];
    
    person.personID = parsedPerson.personID;
    person.active = parsedPerson.active;
    person.pictureURL = parsedPerson.pictureURL;
    person.age = parsedPerson.age;
    person.name = parsedPerson.name;
    person.gender = parsedPerson.gender;
    person.email = parsedPerson.email;
    person.phone = parsedPerson.phone;
    person.address = parsedPerson.address;
    person.registered = [dateFormatter dateFromString:parsedPerson.registered];
}

@end
