//
//  HRModel.m
//  HabraReader
//
//  Created by Sergey Starukhin on 14.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRModel.h"
#import <CoreData/CoreData.h>
#import "HRPDataLoader.h"
#import "HRRSSParser.h"
#import "HRPostLoader.h"
#import "Post+Create.h"
#import "HRCommentsParser.h"

@interface HRModel ()
@property (nonatomic) BOOL isDataBaseExist;
@end

@implementation HRModel

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (id)init {
    self = [super init];
    if (self) {
        //
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return self;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
/*
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
*/
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HabraReader_Prototype" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HabraReader_Prototype.sqlite"];
    
    NSLog(@"data  base file:%@", [storeURL path]);
    self.isDataBaseExist = [[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Network loading stuff

- (void)loadPostsWithCompletionHandler:(void (^)(BOOL))completionHandler {
    // TODO: set offset page =1
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.habrahabr.ru/Page%d/", 1]];
    [HRPDataLoader syncDatabaseWithContext:self.managedObjectContext fromURL:url withCompletionHandler:^(BOOL success){
        // TODO: update ratings
        // определение рейтингов
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        request.predicate = [NSPredicate predicateWithFormat:@"rating > 0"];
        NSError *error;
        NSArray *bestForDay = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (bestForDay) {
            for (Post *post in bestForDay) {
                post.rating = 0;
            }
        }
        [HRRSSParser updateRatingsInManagedObjectContext:self.managedObjectContext withCompletionHandler:completionHandler];
    }];
}

- (void)loadPostsForHub:(NSString *)name withType:(NSString *)type withCompletionHandler:(void (^)(BOOL))completionHandler {
    // TODO: set offset page =1
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.habrahabr.ru/%@/%@/Page%d/", type, name, 1]];
    [HRPDataLoader syncDatabaseWithContext:self.managedObjectContext fromURL:url withCompletionHandler:completionHandler];
}

- (void)loadContentOfPost:(Post *)post withCompletionHandler:(void (^)(BOOL))completionHandler {
    //if (!post.content) {
        // TODO: if post.contenet != nil or != "" - post already loaded
        HRPostLoader *loader = [[HRPostLoader alloc] init];
        [loader loadPostNumber:post.uniqId withCompletionHandler:^(NSString *loadedContent){
            if (loadedContent) {
                post.content = loader.content;
                NSLog(@"------------------------------");
                NSLog(@"Comments:%@", loader.comments);
                if (loader.comments) {
                    // TODO: clean comments for post
                    for (Comment *comment in post.comments) {
                        [post.managedObjectContext deleteObject:comment];
                    }
                    [HRCommentsParser parseCommentsForPost:post fromString:loader.comments];
                }
                completionHandler(YES);
            } else {
                // FIXME: delete post
                completionHandler(NO);
            }
        }];
    //}
    completionHandler(YES);
}

@end
