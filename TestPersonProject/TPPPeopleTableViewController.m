//
//  TPPPeopleTableViewController.m
//  TestPersonProject
//
//  Created by Dim on 30.08.15.
//  Copyright (c) 2015 Dmitriy Baklanov. All rights reserved.
//

#import "TPPPeopleTableViewController.h"
#import <CoreData/NSFetchedResultsController.h>
#import <CoreData/NSFetchRequest.h>
#import <CoreData/NSEntityDescription.h>
#import "TPPDataController.h"


@interface TPPPeopleTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) TPPDataController *dataController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TPPPeopleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.dataController reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters

- (TPPDataController *)dataController {
    
    if (!_dataController) {
        _dataController = [[TPPDataController alloc] init];
    }
    
    return _dataController;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"TPPPerson"
                                      inManagedObjectContext:self.dataController.context];
    
    fetchRequest.fetchBatchSize = 10;
    
    
    NSSortDescriptor *titleDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                      ascending:YES];
    
    fetchRequest.sortDescriptors = @[titleDescriptor];
    
    _fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.dataController.context
                                          sectionNameKeyPath:nil                                                   cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        RSSChannel *channel = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        [[RSSDataManager sharedManager] removeChannel:channel];
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

#pragma mark - Private Methods


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
//    RSSChannel *channel = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    cell.textLabel.text = channel.title;
//    cell.detailTextLabel.text = channel.channel;
}



#pragma mark - Actions




@end
