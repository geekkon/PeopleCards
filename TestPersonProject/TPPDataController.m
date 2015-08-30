//
//  TPPDataController.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPDataController.h"
#import "TPPCoreDataManager.h"
#import "TPPRequestManager.h"
#import "TPPParser.h"

NSString * const URL = @"http://109.120.187.164:81/people.json";

@interface TPPDataController ()

@property (strong, nonatomic) TPPParser *parser;

@end

@implementation TPPDataController

#pragma mark - Getters 

- (NSManagedObjectContext *)context {
    
    return [TPPCoreDataManager sharedManager].context;
}

- (TPPParser *)parser {
    
    if (!_parser) {
        _parser = [[TPPParser alloc] init];
    }
    
    return _parser;
}

#pragma mark - Public

- (void)reloadData {
    
    [[TPPCoreDataManager sharedManager] clearData];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    [self loadDataWithRequest:request];
}

- (void)removeObject:(id)object {
    
}

#pragma mark - Private

- (void)loadDataWithRequest:(NSURLRequest *)request {
    
    __weak typeof(self) weakSelf = self;
    
    [[[TPPRequestManager alloc] init] loadDataWithRequest:request completion:^(NSData *data, NSError *error) {
        
        if (error) {
            
            NSLog(@"Error handling should place to controller %@", [error localizedDescription]);
        } else {
            
            [weakSelf parseData:data];
        }
    }];
}

- (void)parseData:(NSData *)data {
    
    __weak typeof(self) weakSelf = self;
    
    [self.parser parseData:data completion:^(NSArray *objects, NSError *error) {
        
        if (error) {
            
            NSLog(@"Error handling should place to controller %@", [error localizedDescription]);

        } else {
            
            NSLog(@"%@", objects);
        }
    }];
}



@end
