//
//  TPPSortOptionsTableViewController.m
//  TestPersonProject
//
//  Created by Dim on 31.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPSortOptionsTableViewController.h"

NSString * const kOptionsKey      = @"optionsSavingKey";
NSString * const kOptionsTitleKey = @"titleKey";
NSString * const kOptionsValueKey = @"valueKey";

@interface TPPSortOptionsTableViewController ()

@property (strong, nonatomic) NSMutableArray *options;

@end

@implementation TPPSortOptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.editing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters

- (NSMutableArray *)options {
    
    if (!_options) {
        _options = [self readOptionsFromUserDefaults];
    }
    
    return _options;
}

#pragma mark - User Defaults Methods

- (NSMutableArray *)readOptionsFromUserDefaults {
    
    NSArray *options = [[NSUserDefaults standardUserDefaults] arrayForKey:kOptionsKey];
    
    return [NSMutableArray arrayWithArray:options];
}

- (NSArray *)writeDefaultOptionsToUserDefaults {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.options forKey:kOptionsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return self.options;
}

#pragma mark - <UITableViewDataSource>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Sotring order";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
    
    NSDictionary *option = self.options[indexPath.row];
    
    cell.textLabel.text = option[kOptionsTitleKey];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSDictionary *option  = self.options[fromIndexPath.row];
    
    [self.options removeObjectAtIndex:fromIndexPath.row];
    [self.options insertObject:option atIndex:toIndexPath.row];
}

#pragma mark - <UITableViewDelegate>

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Actions

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    
    NSArray *options = [self writeDefaultOptionsToUserDefaults];
    
    if (self.selection) {
        self.selection([NSArray arrayWithArray:options]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
