//
//  TPPParser.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPParser.h"
#import "TPPParsedPerson.h"

@interface TPPParser ()

@property (copy, nonatomic) TPPParserCompletion completion;

@end

@implementation TPPParser

#pragma mark - Public

- (void)parseData:(NSData *)data completion:(TPPParserCompletion)completion {
    
    if (!completion) {
        return;
    }
    
    self.completion = completion;
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf parseData:data];
    });
}

#pragma mark - Private 

- (void)parseData:(NSData *)data {
    
    NSError *error = nil;
    
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    __weak typeof(self) weakSelf = self;

    if (error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.completion(nil, error);
        });
        
    } else {
        
        [weakSelf parseJSONWithArray:JSON];
    }
}

- (void)parseJSONWithArray:(NSArray *)JSON {
    
    if ([NSJSONSerialization isValidJSONObject:JSON]) {
        
        NSMutableArray *parsedPersons = [NSMutableArray array];
        
        for (NSDictionary *person in JSON) {
            
            [parsedPersons addObject:[TPPParsedPerson parsedPersonWithDictionary:person]];
        }
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.completion(parsedPersons, nil);
        });
        
    } else {
        
        NSLog(@"!!!!!!  Parsed DATA is not valid JSON object");
    }
}

@end
