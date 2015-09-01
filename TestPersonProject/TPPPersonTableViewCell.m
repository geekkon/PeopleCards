//
//  TPPPersonTableViewCell.m
//  TestPersonProject
//
//  Created by Dim on 31.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPPersonTableViewCell.h"
#import "TPPPerson.h"
#import "UIImageView+Networking.h"

@interface TPPPersonTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *registeredLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *activeView;

@end

@implementation TPPPersonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public

- (void)configureCellWithPerson:(TPPPerson *)person usingDateFormatter:(NSDateFormatter *)dateFormatter {
    
    self.nameLabel.text = person.name;
    self.genderAgeLabel.text = [NSString stringWithFormat:@"%@, %d years old", person.gender, person.age];
    self.registeredLabel.text = [NSString stringWithFormat:@"Registered: %@", [dateFormatter stringFromDate:person.registered]];
    self.phoneLabel.text = person.phone;
    self.mailLabel.text = person.email;
    self.addressLabel.text = person.address;
    
    self.activeView.backgroundColor = person.active ? [self greenColor] : [self redColor];
    
    __weak typeof(self) weakSelf = self;
    
    self.photImageView.clipsToBounds = YES;
    
    [self.photImageView setImageURL:[NSURL URLWithString:person.pictureURL] withCompletionBlock:^(BOOL succes, UIImage *image, NSError *error) {
        if (succes) {
            weakSelf.photImageView.image = image;
        }
    }];
}

#pragma mark - Private

- (UIColor *)greenColor {
    
    return [UIColor colorWithRed:0.0 green:160.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
}

- (UIColor *)redColor {
    
    return [UIColor redColor];
}

@end
