//
//  AppDelegate.m
//  PodcastCutter
//
//  Created by Arthur Belous on 04.12.12.
//  Copyright (c) 2012 Arthur Belous. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

NSString* OpenFile () // Select file in NSOpenPanel for get path of *.cue or *.mp3 files
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
    //Show instraction window at start
    NSAlert *alert = [[NSAlert alloc] init];
    ///[alert.icon:
    [alert setMessageText:@"Please , choose a *.cue file for cutting ! "];
    [alert runModal];
    
    NSString *SelectedFileIs = OpenFile ();
    NSLog(@" Was selected: %@", SelectedFileIs);
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    CueParser *mycueparser = [[CueParser alloc]init];
    //array = [mycueparser ParseCueFile:SelectedFileIs ];
}


- (IBAction)Cut:(id)sender {
}

- (IBAction)SaveAs:(id)sender {
}

- (IBAction)ChangeYear:(id)sender {
}

- (IBAction)ChangeAtwork:(id)sender {
}

- (IBAction)ChangeAlbumArtist:(id)sender {
}

- (IBAction)ChangeAlbum:(id)sender {
}

- (IBAction)ChangeGenre:(id)sender {
}

- (IBAction)SetNewGenreFromListBox:(id)sender {
}
- (IBAction)CutFile:(id)sender {
}

@end
