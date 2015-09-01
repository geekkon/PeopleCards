//
//  TPPCoreDataManager.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

@import CoreData;

#import "TPPCoreDataManager.h"
#import "TPPPerson.h"
#import "TPPParsedPerson.h"

@interface TPPCoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TPPCoreDataManager

+ (TPPCoreDataManager *)sharedManager {
    
    static TPPCoreDataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TPPCoreDataManager alloc] init];
    });
    
    return manager;
}

- (NSArray *)requestObjectsWithFullFlag:(BOOL)full {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"TPPPerson" inManagedObjectContext:self.managedObjectContext];
    
    if (!full) {
        fetchRequest.fetchLimit = 1;
    }
    
    NSError *requestError = nil;
    
    NSArray *resultArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    if (requestError) {
        return nil;
    }
    
    return resultArray;
}

- (BOOL)isStorageEmpty {
    
    NSArray *objecs = [self requestObjectsWithFullFlag:NO];
    
    return !objecs.count;
}

- (void)clearData {
    
    NSArray *objecs = [self requestObjectsWithFullFlag:YES];

    if (objecs) {
        
        for (TPPPerson *person in objecs) {
            [self.managedObjectContext deleteObject:person];
        }
        
        [self saveContext];
    }
}

- (BOOL)isValidPerson:(TPPParsedPerson *)person {
    
    if ([person.pictureURL isKindOfClass:[NSNull class]]) {
        
        return NO;
    }
    
    if (!person.name || !person.age || !person.gender || !person.pictureURL || !person.phone || !person.email || !person.address || !person.registered) {
        
        return NO;
    }
    
    return YES;
}

- (void)addObjects:(NSArray *)objects {
    
    for (TPPParsedPerson *parsedPerson in objects) {
        
        if ([self isValidPerson:parsedPerson]) {
            [TPPPerson createPersonWithParsedPerson:parsedPerson inContext:self.managedObjectContext usingDateFormatter:self.dateFormatter];
        }
    }
    
    [self saveContext];
}

- (void)removePerson:(TPPPerson *)person {
    
    [self.managedObjectContext deleteObject:person];
    
    [self saveContext];
}

#pragma mark - Getters

- (NSManagedObjectContext *)context {
    
    return self.managedObjectContext;
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter) {
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss ZZ";
    }
    
    return _dateFormatter;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TPPModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TPPModel.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
    
    NSError *error = nil;
    
    BOOL successful = [self.managedObjectContext save:&error];
    
    if (!successful) {
        [NSException raise:@"Error saving" format:@"Reason : %@", [error localizedDescription]];
    }
}

@end
