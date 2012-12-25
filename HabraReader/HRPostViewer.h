//
//  HRPostViewer.h
//  HabraReader
//
//  Created by Sergey Starukhin on 15.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post+Create.h"

@interface HRPostViewer : UIViewController

@property (nonatomic, strong) Post *post;

@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoritesButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *commentsButton;

- (IBAction)reloadPost:(UIBarButtonItem *)sender;
- (IBAction)showComments:(UIBarButtonItem *)sender;
@end
