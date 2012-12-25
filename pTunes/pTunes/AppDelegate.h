//
//  AppDelegate.h
//  pTunes
//
//  Created by mindworm on 11/23/12.
//  Copyright (c) 2012 aquaxp. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSStatusItem *statusItem;
    IBOutlet NSMenu *iTunesOpenMenu;
    IBOutlet NSMenu *iTunesClosedMenu;
    iTunesApplication* iTunes;
    NSImage* image;
}
//state items
@property (weak) IBOutlet NSMenuItem *playItemName;
@property (weak) IBOutlet NSMenuItem *shuffleItemName;
@property (weak) IBOutlet NSMenuItem *lyricsItemName;

// track info
@property (weak) IBOutlet NSMenuItem *menuTrackName;
@property (weak) IBOutlet NSMenuItem *menuArtistName;
@property (weak) IBOutlet NSMenuItem *menuAlbumName;
@property (weak) IBOutlet NSMenuItem *menuComposerName;
@property (weak) IBOutlet NSMenuItem *menuGenreName;
@property (weak) IBOutlet NSMenuItem *menuRatingName;
@property NSString* lyrics;
@property BOOL showMenuInfo;

//- (IBAction)play:(id)sender;
//- (IBAction)shuffle:(id)sender;
//- (IBAction)next:(id)sender;
//- (IBAction)prev:(id)sender;

// Core Functionality
- (void)updateData;
- (void)startWatching;
- (void)stopWatching;
//- (void)checkLyrics;
//- (iTunesEPlS)checkiTunesStatus;

// Menu Changes

- (void)changeToITC;
- (void)changeToITO;

// iTunes Controls
- (IBAction)nextSong:(id)sender;
- (IBAction)prevSong:(id)sender;
- (IBAction)begSong:(id)sender;
- (IBAction)playPauseSong:(id)sender;
- (IBAction)quitItunes:(id)sender;
- (IBAction)openItunes:(id)sender;
- (void)openItunesBegin;
- (void)startPlaying;
- (IBAction)shuffle:(id)sender;
- (IBAction)showWindow:(id)sender;

@end
