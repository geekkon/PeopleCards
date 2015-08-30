//
//  TPPRequestManager.h
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TPPRequestManagerCompletion)(NSData *data, NSError *error);

@interface TPPRequestManager : NSObject

- (void)loadDataWithRequest:(NSURLRequest *)request completion:(TPPRequestManagerCompletion)completion;

@end
