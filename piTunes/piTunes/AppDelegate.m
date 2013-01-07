//
//  AppDelegate.m
//  piTunes
//
//  Created by mindworm on 1/5/13.
//  Copyright (c) 2013 aquaxp. All rights reserved.
//

#import "AppDelegate.h"
#import "LyricsController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self startWatching];
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    notificationCenter.delegate = self;
    [statusItem setTitle:@"π"];
    
    if (![iTunes isRunning]){
        [statusItem setMenu:closedMenu];
        [statusItem setHighlightMode:YES];
        [statusItem setEnabled:YES];
        
    }
    else{
        [statusItem setMenu:playingMenu];
        [statusItem setHighlightMode:YES];
        [statusItem setEnabled:YES];
    }
    
    [self updateData];
    

}

//core func
- (void)startWatching{
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:@"com.apple.iTunes.playerInfo" object:nil];
}

- (void)stopWatching{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateData{
    if (![iTunes isRunning]) {
        [self changeToITC];
    }
    else{
        switch ([iTunes playerState]) {
            case iTunesEPlSStopped:
                [_menuItemPlay setTitle:@"Play"];
                break;
            case iTunesEPlSPaused:
                [_menuItemPlay setTitle:@"Play"];
                break;
            case iTunesEPlSPlaying:
                [_menuItemPlay setTitle:@"Pause"];
                break;
            default:
                [_menuItemPlay setTitle:@"Play/Pause"];
                break;
        }
        [lyricsWindow updateLyrics:[[iTunes currentTrack] lyrics]];
        [self updateMenu];
    }
    [self showNotification];
}

- (void)updateMenu{
    [_menuItemName setTitle:[[iTunes currentTrack] name]];
    [_menuItemArtist setTitle:[[iTunes currentTrack] artist]];
    [_menuItemAlbum setTitle:[[iTunes currentTrack] album]];
    //hide?
    //[_menuItemSeparator0 setHidden:YES]];
    switch ([[iTunes currentPlaylist] songRepeat]) {
        case iTunesERptAll:
            NSLog(@"1");
            //[_menuItemRepeat setTitle:@"Repeat: On"];
            [_menuItemRepeatOn setState:NSOnState];
            [_menuItemRepeatOff setState:NSOffState];
            break;
        case iTunesERptOff:
            NSLog(@"2");
            //[_menuItemRepeat setTitle:@"Repeat: Off"];
            [_menuItemRepeatOn setState:NSOffState];
            [_menuItemRepeatOff setState:NSOnState];
            break;
        case iTunesERptOne:
            NSLog(@"3");
            //[_menuItemRepeat setTitle:@"Repeat: One"];
            [_menuItemRepeatOn setState:NSOffState];
            [_menuItemRepeatOff setState:NSOffState];
            break;
    }
    if([[iTunes currentPlaylist] shuffle] == YES){
        //[_menuItemShuffle setTitle:@"Shuffle: On"];
        [_menuItemShuffleOn setState:NSOnState];
        [_menuItemOff setState:NSOffState];
        
    }
    else if ([[iTunes currentPlaylist] shuffle] == NO){
        //[_menuItemShuffle setTitle:@"Shuffle: Off"];
        [_menuItemShuffleOn setState:NSOffState];
        [_menuItemOff setState:NSOnState];
        
    }
    else{
        //iTUNES doesn't support shuffle(11)
        //[_menuItemShuffle setTitle:@"Shuffle: N/A"];
    }
}

//NotificationCenter func
-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification{
    if ([notification activationType] == NSUserNotificationActivationTypeContentsClicked && [iTunes isRunning]){
        [iTunes activate];
    }
    else if(![iTunes isRunning]){
        [iTunes run];
        [iTunes activate];
        [self changeToITO];
    }
}

-(void)showNotification{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    if([iTunes isRunning]){
        switch ([iTunes playerState]) {
            case iTunesEPlSPaused:
                [notification setTitle:@"Paused"];
                [notification setSubtitle:[[iTunes currentTrack] name]];
                [notification setInformativeText:[[iTunes currentTrack] artist]];
                [notification setActionButtonTitle:@"Show iTunes"];
                [notification setOtherButtonTitle:@"Hide"];
                [notificationCenter deliverNotification: notification];
                break;
            case iTunesEPlSPlaying:
                [notification setTitle:@"Now Playing"];
                [notification setSubtitle:[[iTunes currentTrack] name]];
                [notification setInformativeText:[[iTunes currentTrack] artist]];
                [notification setActionButtonTitle:@"Show iTunes"];
                [notification setOtherButtonTitle:@"Hide"];
                [notificationCenter deliverNotification: notification];
                
                break;
            default:
                break;
        }
    }
    else{
        [notification setTitle:@"iTunes is not running"];
        [notification setSubtitle:@"Please run iTunes"];
        [notification setActionButtonTitle:@"Run iTunes"];
        [notification setOtherButtonTitle:@"Hide"];
        [notificationCenter deliverNotification: notification];
    }
}

//menu change
- (void)changeToITC{
    [statusItem setMenu:closedMenu];
}

- (void)changeToITO{
    [statusItem setMenu:playingMenu];
}

//menu action
- (IBAction)menuItemPlay:(id)sender {
    [iTunes playpause];
}

- (IBAction)menuItemNext:(id)sender {
    [iTunes nextTrack];
}

- (IBAction)menuItemPrevious:(id)sender {
    [iTunes previousTrack];
}

- (IBAction)menuItemShuffleOn:(id)sender {
    
}

- (IBAction)menuItemShuffleOff:(id)sender {
    
}

- (IBAction)menuItemRepeatOn:(id)sender {
    //[_menuItemRepeatOn setState:NSOnState];
    //[_menuItemRepeatOff setState:NSOffState];
    [[iTunes currentPlaylist] setSongRepeat:iTunesERptAll];
}

- (IBAction)menuItemRepeatOff:(id)sender {
    //[_menuItemRepeatOn setState:NSOffState];
    //[_menuItemRepeatOff setState:NSOnState];
    [[iTunes currentPlaylist] setSongRepeat:iTunesERptOff];
}

- (IBAction)menuItemLyrics:(id)sender {
    if(!lyricsWindow){
        lyricsWindow = [[LyricsController alloc] init];
    }
    [lyricsWindow showWindow:self];
    [lyricsWindow updateLyrics:[[iTunes currentTrack] lyrics]];
}

- (IBAction)menuItemPreferences:(id)sender {
    NSLog(@"run preferences");
}


- (IBAction)menuItemRun:(id)sender {
    [iTunes run];
    [self changeToITO];
}


- (void)dealloc{
    [self stopWatching];
}
@end
