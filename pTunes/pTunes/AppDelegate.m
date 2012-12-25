//
//  AppDelegate.m
//  pTunes
//
//  Created by mindworm on 11/23/12.
//  Copyright (c) 2012 aquaxp. All rights reserved.
//

#import "AppDelegate.h"
#import "LyricsWindowController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    ///
    _showMenuInfo = YES;
    ///
    [self startWatching];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    if (![iTunes isRunning]){
        [statusItem setMenu:iTunesClosedMenu];
        [statusItem setTitle:@"x"];
        [statusItem setHighlightMode:YES];
        [statusItem setEnabled:YES];
        
    }
    else{
        [statusItem setMenu:iTunesOpenMenu];
        [statusItem setTitle:@"r"];
        [statusItem setHighlightMode:YES];
        [statusItem setEnabled:YES];
        [self updateData];
    }
    
    //need info
    
}

// core
- (void)startWatching{
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"com.apple.iTunes.playerInfo" object:nil];
}

- (void)stopWatching{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateData{
    if (![iTunes isRunning]) {
        [self changeToITC];
        //[self stopWatching];
    }
    else{
        switch ([iTunes playerState]) {
            case iTunesEPlSStopped:
                [_playItemName setTitle:@"Play"];
                [self updateMenuHead:NO];
                break;
            case iTunesEPlSPaused:
                [_playItemName setTitle:@"Play"];
                [self updateMenuHead:_showMenuInfo];
                break;
            case iTunesEPlSPlaying:
                [_playItemName setTitle:@"Pause"];
                [self updateMenuHead:_showMenuInfo];
                break;
            default:
                [_playItemName setTitle:@"Play/Pause"];
                [self updateMenuHead:NO];
                break;
        }
    }
}

- (void)changeToITC{
    [statusItem setMenu:iTunesClosedMenu];
    [statusItem setTitle:@"x"];
    
}

- (void)changeToITO{
    [statusItem setMenu:iTunesOpenMenu];
    [statusItem setTitle:@"r"];
}

- (IBAction)nextSong:(id)sender{
    [iTunes nextTrack];
}

- (IBAction)prevSong:(id)sender{
    [iTunes previousTrack];
}

- (IBAction)begSong:(id)sender{
    [iTunes backTrack];
}

- (IBAction)playPauseSong:(id)sender{
    [iTunes playpause];
}

- (IBAction)quitItunes:(id)sender {
    [iTunes quit];
    [self changeToITC];
}


- (IBAction)openItunes:(id)sender{
    [iTunes run];
    [self changeToITO];
}

- (void)openItunesBegin{
    [iTunes run];
    [self startPlaying];
}

- (void)startPlaying{
    [iTunes playpause];
	[self changeToITO];
}

- (IBAction)shuffle:(id)sender{
    [[iTunes currentPlaylist] setShuffle:(![[iTunes currentPlaylist] shuffle])];
    NSLog(@"sh");
}

- (IBAction)showWindow:(id)sender {
    [iTunes run];
}

- (void)updateMenuHead:(BOOL)show{    
    if (!show) {
        [_menuTrackName setHidden:YES];
        [_menuArtistName setHidden:YES];
        [_menuAlbumName setHidden:YES];
        [_menuComposerName setHidden:YES];
        [_menuGenreName setHidden:YES];
        //[_menuRatingName setHidden:YES];
            
        [_menuTrackName setTitle:@""];
        [_menuArtistName setTitle:@""];
        [_menuAlbumName setTitle:@""];
        [_menuComposerName setTitle:@""];
        [_menuGenreName setTitle:@""];
        //[_menuRatingName setTitle:@""];
    }
    else{
        [_menuTrackName setHidden:NO];
        [_menuArtistName setHidden:NO];
        [_menuAlbumName setHidden:NO];
        [_menuComposerName setHidden:NO];
        [_menuGenreName setHidden:NO];
        //[_menuRatingName setHidden:NO];
        
        [_menuTrackName setTitle:[[iTunes currentTrack] name]];
        [_menuArtistName setTitle:[[iTunes currentTrack] artist]];
        [_menuAlbumName setTitle:[[iTunes currentTrack] album]];
        [_menuComposerName setTitle:[[iTunes currentTrack] composer]];
        [_menuGenreName setTitle:[[iTunes currentTrack] genre]];
        //[_menuRatingName setTitle:[[iTunes currentTrack] [NSString ]rating]];
    }
}

-(void)dealloc{
    [self stopWatching];
}

@end
