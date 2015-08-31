//
//  TPPPeopleTableViewController.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPPeopleTableViewController.h"
#import "MBProgressHUD.h"
#import "TPPSortOptionsTableViewController.h"
#import <CoreData/NSFetchedResultsController.h>
#import <CoreData/NSFetchRequest.h>
#import <CoreData/NSEntityDescription.h>
#import "TPPDataController.h"
#import "TPPPerson.h"

@interface TPPPeopleTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) TPPDataController *dataController;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TPPPeopleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.dataController.isEmpty) {
        
        [self loadDataWithHUD:YES];
    }
    
    [self configureRefreshControl];
}

#pragma mark - Getters

- (MBProgressHUD *)hud {
    
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        
        [self.view addSubview:_hud];
    }
    
    return _hud;
}

- (TPPDataController *)dataController {
    
    if (!_dataController) {
        _dataController = [[TPPDataController alloc] init];
    }
    
    return _dataController;
}

- (NSArray *)sortDescriptors {
    
    if (!_sortDescriptors) {
        
        NSArray *options = [self readOptionsFromUserDefaults];
        
        if (!options) {
            options = [self writeDefaultOptionsToUserDefaults];
        }
                
        _sortDescriptors = [self makeSortDescriptorsFromOptions:options];
    }
    
    return _sortDescriptors;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"TPPPerson" inManagedObjectContext:self.dataController.context];
    
    fetchRequest.fetchBatchSize = 20;
    
    fetchRequest.sortDescriptors = self.sortDescriptors;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.dataController.context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - User Defaults Methods

- (NSArray *)readOptionsFromUserDefaults {
    
    return [[NSUserDefaults standardUserDefaults] arrayForKey:kOptionsKey];;
}

- (NSArray *)writeDefaultOptionsToUserDefaults {
    
    NSArray *options = @[@{kOptionsTitleKey : @"Name",       kOptionsValueKey : @"name"},
                         @{kOptionsTitleKey : @"Age",        kOptionsValueKey : @"age"},
                         @{kOptionsTitleKey : @"Gender",     kOptionsValueKey : @"gender"},
                         @{kOptionsTitleKey : @"Active",     kOptionsValueKey : @"active"},
                         @{kOptionsTitleKey : @"Registered", kOptionsValueKey : @"registered"}];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:options forKey:kOptionsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return options;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TPPPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.dataController removePerson:person];
    }
}

#pragma mark - <NSFetchedResultsControllerDelegate>

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showSortOptions"]) {
        
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        
        TPPSortOptionsTableViewController *sortOptionsViewController = (TPPSortOptionsTableViewController *)navigationController.topViewController;
        
        __weak typeof(self) weakSelf = self;
      
        [sortOptionsViewController setSelection:^(NSArray *options) {
            [weakSelf sortResultsUsingOptions:options];
        }];
    }

}

#pragma mark - Private Methods

- (void)showAletWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
}

- (void)configureRefreshControl {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(UIRefreshControl *)sender {
    
    [self loadDataWithHUD:NO];
}

- (void)loadDataWithHUD:(BOOL)showHUD {
    
    if (showHUD) {
        
        [self.hud show:YES];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [self.dataController reloadDataWithCompletion:^(NSError *error) {
        
        [weakSelf.hud hide:YES];
        [weakSelf.refreshControl endRefreshing];
        
        if (error) {
            
            [weakSelf showAletWithError:error];
        }
    }];
}

- (NSArray *)makeSortDescriptorsFromOptions:(NSArray *)options {
    
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    
    for (NSDictionary *option in options) {
        [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:option[kOptionsValueKey] ascending:YES]];
    }
    
    return sortDescriptors;
}

- (void)sortResultsUsingOptions:(NSArray *)options {
    
    NSLog(@"%@", options);
    
    self.sortDescriptors = [self makeSortDescriptorsFromOptions:options];
    
    self.fetchedResultsController = nil;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    TPPPerson *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.gender;
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", person.age];
}

@end
