//
//  DSAppDelegate.h
//  Carti Audio
//
//  Created by Dmitry on 07.12.12.
//  Copyright (c) 2012 Dmitry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSViewController;

@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DSViewController *viewController;

@end
