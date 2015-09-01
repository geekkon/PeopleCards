//
//  TPPCoreDataManager.h
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TPPPerson;

@interface TPPCoreDataManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

+ (TPPCoreDataManager *)sharedManager;

- (BOOL)isStorageEmpty;

- (void)clearData;

- (void)addObjects:(NSArray *)objects;
- (void)removePerson:(TPPPerson *)person;

@end
