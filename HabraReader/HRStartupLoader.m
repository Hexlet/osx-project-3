//
//  HRStartupLoader.m
//  HabraReader
//
//  Created by Sergey on 16.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRStartupLoader.h"
#import "HRAppDelegate.h"
#import "Post+Create.h"

@interface HRStartupLoader ()
@property (nonatomic, strong) HRModel *model;
@end

@implementation HRStartupLoader

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // TODO:если файла с БД нет - то проводим первичную инициализацию, если есть - переходим на глагне
    HRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.model = appDelegate.model;
    if (self.model.isDataBaseExist) {
        NSLog(@"data already loaded");
        [self performSegueWithIdentifier:@"loadComplete" sender:nil];
    } else {
        NSLog(@"loading data");
       [self.model loadPostsWithCompletionHandler:^(BOOL success){
            [self performSegueWithIdentifier:@"loadComplete" sender:nil];
        }];
    }
}

#pragma mark - My stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // TODO: set context for iPad
        /*        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
         UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
         splitViewController.delegate = (id)navigationController.topViewController;
         
         UINavigationController *masterNavigationController = [splitViewController.viewControllers objectAtIndex:0];
         HRPMasterViewController *controller = (HRPMasterViewController *)masterNavigationController.topViewController;
         controller.managedObjectContext = self.managedObjectContext;*/
    } else {
        //UITabBarController *tabBarController = (UITabBarController *)segue.destinationViewController;
        //for (UINavigationController *navController in tabBarController.viewControllers) {
            UINavigationController *controller = (UINavigationController *)segue.destinationViewController;
            //[controller setManagedObjectContext:self.managedObjectContext];
            if ([controller.topViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
                // use performSelector:withObject: to send without compiler checking
                // (which is acceptable here because we used introspection to be sure this is okay)
                NSLog(@"%s",__PRETTY_FUNCTION__);
                [controller.topViewController performSelector:@selector(setManagedObjectContext:) withObject:self.model.managedObjectContext];
            }
        //}
        /*id controller = self.window.rootViewController;
         if ([controller respondsToSelector:@selector(setManagedObjectContext:)]) {
         // use performSelector:withObject: to send without compiler checking
         // (which is acceptable here because we used introspection to be sure this is okay)
         [controller performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
         }*/
        //HRPMasterViewController *controller = (HRPMasterViewController *)navigationController.topViewController;
        //controller.managedObjectContext = self.managedObjectContext;
    }
    
}

@end
