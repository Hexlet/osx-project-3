//
//  HRListOfGenericHubs.m
//  HabraReader
//
//  Created by Sergey on 10.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRListOfGenericHubs.h"
#import "GenericHub.h"

@implementation HRListOfGenericHubs

@dynamic managedObjectContext;
//@synthesize managedObjectContext = _managedObjectContext;
/*
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext != _managedObjectContext) {
        _managedObjectContext = managedObjectContext;
        // TODO: Create NSFetchRequestController
        //self.debug = YES;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hub"];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        // no predicate because we want ALL the Hubs
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
    }
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    /*
     UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
     self.navigationItem.rightBarButtonItem = addButton;*/
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    //self.detailViewController = (HRPDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    NSLog(@"Frame height:%f",self.tabBarController.tabBar.bounds.size.height);
    self.tableView.rowHeight = (self.tableView.bounds.size.height - (44.0 + 49.0)) / 8;// FIXME: magic numbers (navigationBar + tabBar) height
}

- (IBAction)addGenericHub:(UIBarButtonItem *)sender {
    // TODO: запросить название хаба, проверить наличие и добавить в базу
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GenericHub Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    GenericHub *hub = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = hub.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d posts", [hub.posts count]];
    
    return cell;
}

// 19. Support segueing from this table to any view controller that has a photographer @property.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    GenericHub *hub = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segue.destinationViewController respondsToSelector:@selector(setTitle:)]) {
        [segue.destinationViewController performSelector:@selector(setTitle:) withObject:hub.title];
    }
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
        //[hub fetchPostsFromPage:1 withCompletionHandler:^(BOOL success){
            // TODO: do something...
        //}];
        [segue.destinationViewController performSelector:@selector(setFetchedResultsController:) withObject:postsOfHub];
    }
}

@end
