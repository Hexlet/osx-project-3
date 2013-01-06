//
//  AppDelegate.h
//  PodcastCutter
//
//  Created by Arthur Belous on 04.12.12.
//  Copyright (c) 2012 Arthur Belous. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CueParser.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
NSMutableArray *arrayOfMp3Index;
NSMutableArray *arrayOfMp3Title;
NSMutableArray *arrayOfMp3Performer;
    NSMutableArray *arrayOfMp3Track;}
@property (assign) IBOutlet NSWindow *window;

-(NSString*) OpenFile;


@property (weak) IBOutlet NSTextField *albumArtist;
@property (weak) IBOutlet NSTextField *albumTitle;
@property (weak) IBOutlet NSComboBox *genreTypeList;


@end
