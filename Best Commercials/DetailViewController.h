//
//  DetailViewController.h
//  Best Commercials
//
//  Created by herku on 12/3/12.
//  Copyright (c) 2012 Advert.Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

