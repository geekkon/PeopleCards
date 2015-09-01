//
//  TPPPersonTableViewCell.h
//  TestPersonProject
//
//  Created by Dim on 31.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPPPerson;

@interface TPPPersonTableViewCell : UITableViewCell

- (void)configureCellWithPerson:(TPPPerson *)person usingDateFormatter:(NSDateFormatter *)dateFormatter;

@end
