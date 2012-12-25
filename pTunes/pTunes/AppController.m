//
//  AppController.m
//  pTunes
//
//  Created by mindworm on 12/23/12.
//  Copyright (c) 2012 aquaxp. All rights reserved.
//

#import "AppController.h"
#import "LyricsWindowController.h"
#import "PreferencesWindowController.h"


@implementation AppController
-(IBAction)showPreferencesPanel:(id)sender{
    if(!preferences){
        preferences = [[PreferencesWindowController alloc] init];
    }
    [preferences showWindow:self];
}
-(IBAction)showLyricsWindow:(id)sender{
    if(!lyrics){
        lyrics = [[LyricsWindowController alloc] init];
    }
    [lyrics showWindow:self];
}
@end
