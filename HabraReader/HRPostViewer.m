//
//  HRPostViewer.m
//  HabraReader
//
//  Created by Sergey Starukhin on 15.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRPostViewer.h"
#import "HRAppDelegate.h"
#import "GenericHub.h"

@interface HRPostViewer () <UIWebViewDelegate> {
    NSUInteger state;
}

@property (nonatomic, strong) HRModel *model;

@end

@implementation HRPostViewer

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
    HRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.model = appDelegate.model;
    self.browser.delegate = self;
    self.browser.scalesPageToFit = YES;
    [self reloadPost:self.navigationItem.rightBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBrowser:nil];
    [self setFavoritesButton:nil];
    [self setCommentsButton:nil];
    [super viewDidUnload];
}

- (IBAction)addToFavorites:(UIBarButtonItem *)sender {
    self.post.inFavorites = ! self.post.inFavorites;
    [self updateTitle];
}

- (IBAction)reloadPost:(UIBarButtonItem *)sender {
    NSString *loadString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"load" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    [self.browser loadHTMLString:loadString baseURL:[NSURL URLWithString:@"http://m.habrahabr.ru"]];

    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    [self.model loadContentOfPost:self.post withCompletionHandler:^(BOOL success){
        self.navigationItem.rightBarButtonItem = sender;
        [self updateTitle];
        if (success) {
            [self.browser loadHTMLString:self.post.content baseURL:[NSURL URLWithString:@"http://m.habrahabr.ru"]];
        } else {
            // TODO: error handle
            [self.browser loadHTMLString:@"Error..." baseURL:[NSURL URLWithString:@"http://m.habrahabr.ru"]];
        }
    }];
}

- (IBAction)showComments:(UIBarButtonItem *)sender {
    // TODO: segue to CommentsViewController
    //[self reloadPost:self.navigationItem.rightBarButtonItem];
}

- (void)updateTitle {
    self.favoritesButton.title = self.post.inFavorites ? @"Remove from favorites" : @"Add to favorites";
    NSUInteger numberOfComments = [self.post countOfComments];
    self.commentsButton.enabled = numberOfComments ? YES : NO;
    self.commentsButton.title = [NSString stringWithFormat:@"%d comments", numberOfComments];
}

#pragma mark - UIWebViewDelegate Protocol
/*
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    //webView.scalesPageToFit = YES;
}
*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL permitRequest = YES;
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
            permitRequest = NO;
            if ([request.URL.host isEqualToString:@"m.habrahabr.ru"]) {
                //NSLog(@"path components:%@",request.URL.pathComponents);
                NSArray *pathComponents = request.URL.pathComponents;
                if (pathComponents.count > 1) {
                    NSLog(@"hub or company name:%@",[pathComponents lastObject]);
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[[pathComponents objectAtIndex:1] capitalizedString]]; // entiti name Hub or Company
                    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [pathComponents lastObject]];
                    NSError *error;
                    NSArray *hubs = [self.post.managedObjectContext executeFetchRequest:request error:&error];
                    if (hubs) {
                        [self performSegueWithIdentifier:@"showHubOrCompany" sender:[hubs lastObject]];
                    }
                }
            } else if ([request.URL.host isEqualToString:@"habrahabr.ru"]) {
                NSArray *pathComponents = request.URL.pathComponents;
                if ([[pathComponents objectAtIndex:1] isEqualToString:@"post"]) {
                    // TODO: Show post
                    HRPostViewer *anotherPostViewer = [[HRPostViewer alloc] init];
                    NSLog(@"post Id:%@",[pathComponents lastObject]);
                    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[[pathComponents objectAtIndex:1] capitalizedString]]; // entiti name Hub or Company
                    request.predicate = [NSPredicate predicateWithFormat:@"uniqId = %@", [pathComponents lastObject]];
                    NSError *error;
                    NSArray *posts = [self.post.managedObjectContext executeFetchRequest:request error:&error];
                    if (posts) {
                        anotherPostViewer.post = [posts lastObject];
                        //[self.navigationController pushViewController:anotherPostViewer animated:YES]; //FIXME: not working!!!
                    }
                }
            }
            NSLog(@"link clicked:%@",request);
            break;
            
        case UIWebViewNavigationTypeOther:
            // здесь идет загрузка контента страницы
            //NSLog(@"navigation other:%@",request);
            //permitRequest = NO;
            break;
            
        default:
            break;
    }
    return permitRequest; // TODO: filter navigationType
}

#pragma mark - Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    GenericHub *hub = sender; // FIXME: Временное решение передавать хаб или компанию через сендера
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
                                                                                     managedObjectContext:self.post.managedObjectContext
                                                                                       sectionNameKeyPath:nil
                                                                                                cacheName:nil];
        //[hub fetchPostsFromPage:1 withCompletionHandler:^(BOOL success){
            // TODO: do something...
        //}];
        HRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.model loadPostsForHub:hub.name withType:hub.entity.name withCompletionHandler:^(BOOL success){
            // TODO: do something...
        }];
        [segue.destinationViewController performSelector:@selector(setFetchedResultsController:) withObject:postsOfHub];
    }
    if ([[segue.destinationViewController class] isSubclassOfClass:[UINavigationController class]]) {
        UIViewController *conroller = [(UINavigationController *)segue.destinationViewController topViewController];
        if ([conroller respondsToSelector:@selector(setMessage:)]) {
            [conroller performSelector:@selector(setMessage:) withObject:self.post];
        }
    }
}

@end
