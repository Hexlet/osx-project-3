//
//  HRGenericHubTableViewController.m
//  HabraReader
//
//  Created by Sergey on 09.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRHubTableViewController.h"

@implementation HRHubTableViewController

@synthesize managedObjectContext = _managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext != _managedObjectContext) {
        _managedObjectContext = managedObjectContext;
        // TODO: Create NSFetchRequestController
        //self.debug = YES;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hub"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        // no predicate because we want ALL the Hubs
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];

    }
    self.title = @"Hubs"; // FIXIT: Да быдлокод, а куда его ещё вставить?
}
/*
- (IBAction)addGenericHub:(UIBarButtonItem *)sender {
    // TODO: запросить название хаба, проверить наличие и добавить в базу
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Hub Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Hub *hub = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = hub.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d posts", [hub.posts count]];
    
    return cell;
}

// 19. Support segueing from this table to any view controller that has a photographer @property.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Hub *hub = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a photographer @property
    if ([segue.destinationViewController respondsToSelector:@selector(setFetchedResultsController:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"publicationDate" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [request setSortDescriptors:sortDescriptors];
        request.predicate = [NSPredicate predicateWithFormat:@"ANY hubs.name like %@", hub.name];
        
        //request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nickName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        NSFetchedResultsController *postsOfHub = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                     managedObjectContext:self.managedObjectContext
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:nil];
        [segue.destinationViewController performSelector:@selector(setParentHub:) withObject:hub];
        [segue.destinationViewController performSelector:@selector(setFetchedResultsController:) withObject:postsOfHub];
    }
}
*/
@end
