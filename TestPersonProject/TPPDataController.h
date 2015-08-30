//
//  TPPDataController.h
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface TPPDataController : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

- (void)updateData;

@end
