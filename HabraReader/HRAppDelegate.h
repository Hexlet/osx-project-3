//
//  HRAppDelegate.h
//  HabraReader
//
//  Created by Sergey Starukhin on 06.09.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRModel.h"

@interface HRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) HRModel *model;

@end
