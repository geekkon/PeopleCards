//
//  TPPParser.h
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TPPParserCompletion)(NSArray *objects, NSError *error);

@interface TPPParser : NSObject

// parse data on background thread and perfom completion on main thread
- (void)parseData:(NSData *)data completion:(TPPParserCompletion)completion;

@end
