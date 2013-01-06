//
//  AppDelegate.m
//  PodcastCutter
//
//  Created by Arthur Belous on 04.12.12.
//  Copyright (c) 2012 Arthur Belous. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

-(NSString*) OpenFile // Select file in NSOpenPanel for get path of *.cue or *.mp3 files
{
    NSString *FilePath;
    // Define file types for our app, exclud all the other extension formats
    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"cue", @"Cue", @"CUE", nil];
    
    // Create instance of NSOpenPanel
    NSOpenPanel *myOpenPanel = [NSOpenPanel openPanel];
    
    //Set parameters for our open panel
    [myOpenPanel setAllowsMultipleSelection:NO];
    [myOpenPanel setAllowedFileTypes:fileTypes];
    [myOpenPanel setAllowsOtherFileTypes:NO];
    
    if ( [myOpenPanel runModal] == NSOKButton )
    {
        FilePath = [[myOpenPanel URL]path]; // Get file path of selected *.cue file
    }
    return FilePath;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Please , choose a *.cue file for cutting ! "];
    [alert runModal];
    
    NSString *SelectedFileIs = [self OpenFile];
    
    
    [mycueparser ParseCueFile:SelectedFileIs ];
    
   
    
    NSString * albumArtist = [mycueparser RetMp3Performer];
    [self.albumArtist setStringValue:albumArtist];
    
    NSString * album = [mycueparser RetMp3Title];
    [self.albumTitle setStringValue:album];
    
    //[self.genreTypeList setValuesForKeysWithDictionary:<#(NSDictionary *)#>]
}

@end
