//
//  TPPSortOptionsTableViewController.h
//  TestPersonProject
//
//  Created by Dim on 31.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kOptionsKey;
extern NSString * const kOptionsTitleKey;
extern NSString * const kOptionsValueKey;

typedef void (^TPPSortOptionsTableViewControllerSelection)(NSArray *options);

@interface TPPSortOptionsTableViewController : UITableViewController

@property (copy, nonatomic) TPPSortOptionsTableViewControllerSelection selection;

@end
