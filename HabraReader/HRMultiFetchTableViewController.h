//
//  HRMultiFetchTableViewController.h
//  HabraReader
//
//  Created by Sergey Starukhin on 11.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMultiFetchTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;

- (void)performFetch;

@end
