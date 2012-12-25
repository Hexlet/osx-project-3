//
//  HRListOfGenericHubs.h
//  HabraReader
//
//  Created by Sergey on 10.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface HRListOfGenericHubs : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)addGenericHub:(UIBarButtonItem *)sender;

@end
