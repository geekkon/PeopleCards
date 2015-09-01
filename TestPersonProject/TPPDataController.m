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

@property (copy, nonatomic) TPPDataControllerCompletion completion;

@property (strong, nonatomic) TPPRequestManager *requestManager;
@property (strong, nonatomic) TPPParser *parser;

@end

@implementation TPPDataController

#pragma mark - Getters 

- (BOOL)isEmpty {
    
    return [[TPPCoreDataManager sharedManager] isStorageEmpty];
}

- (NSManagedObjectContext *)context {
    
    return [TPPCoreDataManager sharedManager].context;
}

- (TPPRequestManager *)requestManager {
    
    if (!_requestManager) {
        _requestManager = [[TPPRequestManager alloc] init];
    }
    
    return _requestManager;
}

- (TPPParser *)parser {
    
    if (!_parser) {
        _parser = [[TPPParser alloc] init];
    }
    
    return _parser;
}

#pragma mark - Public

- (void)reloadDataWithCompletion:(TPPDataControllerCompletion)completion {
    
    if (!completion) {
        return;
    }
    
    self.completion = completion;
    
    [[TPPCoreDataManager sharedManager] clearData];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    [self loadDataWithRequest:request];
}

- (void)removePerson:(TPPPerson *)person {
    
    [[TPPCoreDataManager sharedManager] removePerson:person];
}

#pragma mark - Private

- (void)loadDataWithRequest:(NSURLRequest *)request {
    
    __weak typeof(self) weakSelf = self;
    
    [self.requestManager loadDataWithRequest:request completion:^(NSData *data, NSError *error) {
        
        if (error) {
            weakSelf.completion(error);
        } else {
            [weakSelf parseData:data];
        }
    }];
}

- (void)parseData:(NSData *)data {
    
    __weak typeof(self) weakSelf = self;
    
    [self.parser parseData:data completion:^(NSArray *objects, NSError *error) {
        
        if (error) {
            weakSelf.completion(error);
        } else {
            [weakSelf addObjects:objects];
        }
    }];
}

- (void)addObjects:(NSArray *)objects {
    
    [[TPPCoreDataManager sharedManager] addObjects:objects];
    
    self.completion(nil);
}

@end
