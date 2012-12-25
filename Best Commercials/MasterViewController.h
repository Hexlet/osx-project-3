//
//  MasterViewController.h
//  Best Commercials
//
//  Created by herku on 12/3/12.
//  Copyright (c) 2012 Advert.Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

- (IBAction)refresh:(id)sender;

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UITableView *commercialsList;


+ (NSInteger)page;


@end
