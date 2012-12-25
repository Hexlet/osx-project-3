//
//  HRCommentsTableController.h
//  HabraReader
//
//  Created by Sergey Starukhin on 20.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message+Count.h"

@interface HRCommentsTableController : UITableViewController

@property (nonatomic, strong) Message *message;

- (IBAction)returnToPostViewer:(UIBarButtonItem *)sender;
@end
