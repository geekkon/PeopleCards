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
    
    parsedPerson.name = dictionary[@"name"];
    
    
//    parsedObject.name = JSON[@"name"];
//    parsedObject.country = JSON[@"sys"][@"country"];
//    parsedObject.cityID =  JSON[@"id"] ;
//    parsedObject.lon = JSON[@"coord"][@"lon"];
//    parsedObject.lat = JSON[@"coord"][@"lat"];
//    
//    NSArray *weather = JSON[@"weather"];
//    
//    if ([weather firstObject]) {
//        parsedObject.conditionID = [weather firstObject][@"id"];
//        parsedObject.icon = [weather firstObject][@"icon"];
//        parsedObject.info = [weather firstObject][@"description"];
//        parsedObject.main = [weather firstObject][@"main"];
//    }
//    
//    parsedObject.temp = JSON[@"main"][@"temp"];
//    parsedObject.updateTime = JSON[@"dt"];
    
    return parsedPerson;
}

- (NSString *)description {
    return self.name;
}

@end
