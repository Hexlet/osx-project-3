//
//  AppController.m
//  timer
//
//  Created by Максим on 19.12.12.
//  Copyright (c) 2012 CarelessApps. All rights reserved.
//

#import "AppController.h"
#import "Preferences.h"

@implementation AppController

-(IBAction)showPref:(id)sender{
    if (!pref) {
        pref = [[Preferences alloc]init];
    }
    [pref showWindow:self];
}

@end
