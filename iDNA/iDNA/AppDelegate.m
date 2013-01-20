//
//  AppDelegate.m
//  iDNA
//
//  Created by Dmitry Davidov on 24.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "AppDelegate.h"

#import "AppDefaults.h"


@implementation AppDelegate

+ (void)initialize
{
    [super initialize];
    [AppDefaults setupDefaults];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

@end
