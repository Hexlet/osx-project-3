//
//  HRModel.h
//  HabraReader
//
//  Created by Sergey Starukhin on 14.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Post;

@interface HRModel : NSObject

@property (readonly, nonatomic) BOOL isDataBaseExist;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;
- (void)loadPostsWithCompletionHandler:(void (^)(BOOL))completionHandler;
- (void)loadPostsForHub:(NSString *)name withType:(NSString *)type withCompletionHandler:(void (^)(BOOL))completionHandler;

- (void)loadContentOfPost:(Post *)post withCompletionHandler:(void (^)(BOOL))completionHandler;

@end
