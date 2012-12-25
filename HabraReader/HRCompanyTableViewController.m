//
//  HRCompanyTableViewController.m
//  HabraReader
//
//  Created by Sergey on 09.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRCompanyTableViewController.h"

@implementation HRCompanyTableViewController

@synthesize managedObjectContext = _managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext != _managedObjectContext) {
        _managedObjectContext = managedObjectContext;
        // TODO: Create NSFetchRequestController
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Company"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        // no predicate because we want ALL the Hubs
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
    }
    self.title = @"Companies"; // FIXIT: Да быдлокод, а куда его ещё вставить?
}
/*
- (IBAction)addCompany:(UIBarButtonItem *)sender {
    // TODO: запросить название хаба, проверить наличие и добавить в базу
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Company Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Company *company = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = company.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d posts", [company.posts count]];
    
    return cell;
}

// 19. Support segueing from this table to any view controller that has a photographer @property.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Company *company = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a photographer @property
    if ([segue.destinationViewController respondsToSelector:@selector(setFetchedResultsController:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"publicationDate" ascending:NO];
        NSArray *sortDescriptors = @[sortDescriptor];
        
        [request setSortDescriptors:sortDescriptors];
        request.predicate = [NSPredicate predicateWithFormat:@"ANY hubs.name like %@", company.name];
        
        //request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nickName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        NSFetchedResultsController *postsOfCompany = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                         managedObjectContext:self.managedObjectContext
                                                                                           sectionNameKeyPath:nil
                                                                                                    cacheName:nil];
        [segue.destinationViewController performSelector:@selector(setParentHub:) withObject:company];
        [segue.destinationViewController performSelector:@selector(setFetchedResultsController:) withObject:postsOfCompany];
    }
}
*/
@end
