//
//  TPPPerson.h
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TPPParsedPerson;

@interface TPPPerson : NSManagedObject

@property (nonatomic, retain) NSString * personID;
@property (nonatomic)         BOOL       active;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic)         int16_t    age;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate   * registered;

+ (void)createPersonWithParsedPerson:(TPPParsedPerson *)parsedPerson inContext:(NSManagedObjectContext *)context usingDateFormatter:(NSDateFormatter *)dateFormatter;

@end
