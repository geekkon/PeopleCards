//
//  TPPRequestManager.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPRequestManager.h"

@interface TPPRequestManager ()

@property (copy, nonatomic) TPPRequestManagerCompletion completion;

@end

@implementation TPPRequestManager

#pragma mark - Public

- (void)loadDataWithRequest:(NSURLRequest *)request completion:(TPPRequestManagerCompletion)completion {
    
    if (!completion) {
        return;
    }
    
    self.completion = completion;
    
    [self loadDataWithRequest:request];

}

#pragma mark - Private

- (void)loadDataWithRequest:(NSURLRequest *)request {
    
    [[NSURLSession sharedSession] invalidateAndCancel];
    
    __weak typeof(self) weakSelf = self;

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                weakSelf.completion(nil, error);
            } else {
                weakSelf.completion(data, nil);
            }
        });
        
    }] resume];
}

@end
