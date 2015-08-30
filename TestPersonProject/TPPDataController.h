//
//  TPPDataController.h
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext, TPPPerson;

typedef void (^TPPDataControllerCompletion)(BOOL success, NSError *error);

@interface TPPDataController : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

- (void)reloadDataWithCompletion:(TPPDataControllerCompletion)completion;

- (void)removeObject:(TPPPerson *)person;

@end
