//
//  TPPRequestManager.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPRequestManager.h"

@implementation TPPRequestManager

- (void)loadDataWithRequest:(NSURLRequest *)request completion:(TPPRequestManagerCompletion)completion {
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(nil, error);
            } else {
                completion(data, nil);
            }
        });
        
    }] resume];
}

@end
