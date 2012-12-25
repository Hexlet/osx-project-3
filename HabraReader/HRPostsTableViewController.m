//
//  HRPostsTableViewController.m
//  HabraReader
//
//  Created by Sergey on 09.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRPostsTableViewController.h"
#import "Post+Create.h"
#import "HRAppDelegate.h"

@interface HRPostsTableViewController ()
@property (nonatomic, strong) HRModel *model;
@end

@implementation HRPostsTableViewController

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
    NSLog(@"Table Viewr:%f",self.tableView.bounds.size.height);
    self.tableView.rowHeight = (self.tableView.bounds.size.height - (44.0 + 0)) / 6.0; // FIXME: (navigationBar + tabBar(49.0)) height
    HRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.model = appDelegate.model;
}
/*
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"setting rowHeight");
    [super viewWillAppear:animated];
}
*/
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self refreshData:self.navigationController.navigationItem.rightBarButtonItem];
}

- (IBAction)refreshData:(UIBarButtonItem *)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    //[Post fetchPostsFromPage:1 inManagedObjectContext:self.fetchedResultsController.managedObjectContext withCompletionHandler:^(BOOL success){
    [self.model loadPostsWithCompletionHandler:^(BOOL success){
        self.navigationItem.rightBarButtonItem = sender;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Post Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Then configure the cell using it ...
    cell.textLabel.text = post.title;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d comments", post.countOfComments];
    cell.detailTextLabel.text = [post.publicationDate description];
    //cell.bounds.size.height = tableView.bounds.size.height / 6;

    return cell;
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.bounds.size.height / 6;
}*/
// 19. Support segueing from this table to any view controller that has a photographer @property.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([segue.destinationViewController respondsToSelector:@selector(setTitle:)]) {
        [segue.destinationViewController performSelector:@selector(setTitle:) withObject:post.title];
    }
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a photographer @property
    if ([segue.destinationViewController respondsToSelector:@selector(setPost:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        [segue.destinationViewController performSelector:@selector(setPost:) withObject:post];
    }
}

@end
