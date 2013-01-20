//
//  AppDelegate.h
//  iDNA
//
//  Created by Dmitry Davidov on 24.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property NSUInteger size;
@property NSUInteger length;
@property NSUInteger mutatePercent;

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
