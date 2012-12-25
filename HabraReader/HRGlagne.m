//
//  HRGlagne.m
//  HabraReader
//
//  Created by Sergey Starukhin on 11.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "HRGlagne.h"
#import "Post+Create.h"
#import "HRAppDelegate.h"

@interface HRGlagne ()
@property (nonatomic, strong) HRModel *model;
@end

@implementation HRGlagne

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Глагне";
    self.tableView.rowHeight = (self.tableView.bounds.size.height - self.navigationController.navigationBar.bounds.size.height) / 6.0;

    HRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.model = appDelegate.model;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSFetchRequest *bestForTheDay = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    bestForTheDay.fetchLimit = 3;
    bestForTheDay.predicate = [NSPredicate predicateWithFormat:@"rating > 0"];
    bestForTheDay.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"rating" ascending:NO]];
    NSFetchedResultsController *frc24 = [[NSFetchedResultsController alloc] initWithFetchRequest:bestForTheDay
                                                                            managedObjectContext:self.model.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    request.predicate = [NSPredicate predicateWithFormat:@"inFavorites = YES"];
    request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"publicationDate" ascending:NO]];
    NSFetchedResultsController *favorites = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                managedObjectContext:self.model.managedObjectContext
                                                                                  sectionNameKeyPath:nil
                                                                                           cacheName:nil];
    
    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    request2.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"publicationDate" ascending:NO]];
    // no predicate because we want ALL the Hubs
    
    NSFetchedResultsController *frc2 = [[NSFetchedResultsController alloc] initWithFetchRequest:request2
                                                                           managedObjectContext:self.model.managedObjectContext
                                                                             sectionNameKeyPath:nil
                                                                                      cacheName:nil];
    self.titles = [NSArray arrayWithObjects:@"best for 24 hour", @"favorites", @"feed", nil];
    self.sections = [NSArray arrayWithObjects:frc24, favorites, frc2, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Glagne Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSFetchedResultsController *frc = [self.sections objectAtIndex:indexPath.section];
    Post *post = [frc objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    cell.textLabel.text = post.title;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d comments", post.countOfComments];
    cell.detailTextLabel.text = [post.publicationDate description];

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    // FIXME: индусский код
    UIViewController *controller = segue.destinationViewController;
    // be somewhat generic here (slightly advanced usage)
    // we'll segue to ANY view controller that has a photographer @property
    if ([controller respondsToSelector:@selector(setPost:)]) {
        // use performSelector:withObject: to send without compiler checking
        // (which is acceptable here because we used introspection to be sure this is okay)
        NSLog(@"%@",sender);
        NSIndexPath *selectedCellIndexPath = [self.tableView indexPathForCell:sender];
        Post *post = [[self.sections objectAtIndex:selectedCellIndexPath.section] objectAtIndexPath:[NSIndexPath indexPathForRow:selectedCellIndexPath.row inSection:0]];
        controller.title = post.title;
        [controller performSelector:@selector(setPost:) withObject:post];
    }
}

- (IBAction)glagneReload:(UIBarButtonItem *)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    //[Post fetchPostsFromPage:1 inManagedObjectContext:self.model.managedObjectContext withCompletionHandler:^(BOOL success){
    [self.model loadPostsWithCompletionHandler:^(BOOL success){
        self.navigationItem.rightBarButtonItem = sender;
    }];

}
@end
