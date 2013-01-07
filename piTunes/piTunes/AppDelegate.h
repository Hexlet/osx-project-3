//
//  AppDelegate.h
//  piTunes
//
//  Created by mindworm on 1/5/13.
//  Copyright (c) 2013 aquaxp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"

@class LyricsController;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate>{
    NSStatusItem *statusItem;
    IBOutlet NSMenu *playingMenu;
    IBOutlet NSMenu *closedMenu;
    iTunesApplication* iTunes;
    NSUserNotificationCenter *notificationCenter;
    LyricsController *lyricsWindow;
    
    //temporary
    NSImage* image;
}

//iTunes playing menu items
@property (weak) IBOutlet NSMenuItem *menuItemName;
@property (weak) IBOutlet NSMenuItem *menuItemArtist;
@property (weak) IBOutlet NSMenuItem *menuItemAlbum;
@property (weak) IBOutlet NSMenuItem *menuItemSeparator0;
@property (weak) IBOutlet NSMenuItem *menuItemPlay;
@property (weak) IBOutlet NSMenuItem *menuItemShuffleOn;
@property (weak) IBOutlet NSMenuItem *menuItemOff;
@property (weak) IBOutlet NSMenuItem *menuItemRepeatOn;
@property (weak) IBOutlet NSMenuItem *menuItemRepeatOff;

- (IBAction)menuItemPlay:(id)sender;
- (IBAction)menuItemNext:(id)sender;
- (IBAction)menuItemPrevious:(id)sender;
- (IBAction)menuItemShuffleOn:(id)sender;
- (IBAction)menuItemShuffleOff:(id)sender;
- (IBAction)menuItemRepeatOn:(id)sender;
- (IBAction)menuItemRepeatOff:(id)sender;
- (IBAction)menuItemLyrics:(id)sender;

//iTunes shared items
- (IBAction)menuItemPreferences:(id)sender;

//iTunes closed menu items
@property (weak) IBOutlet NSMenuItem *menuItemStatus;
@property (weak) IBOutlet NSMenuItem *menuItemRun;

- (IBAction)menuItemRun:(id)sender;

@end
