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

@property (assign) IBOutlet NSWindow *window;

NSString *OpenFile();
- (IBAction)CutFile:(id)sender;
- (IBAction)SaveAs:(id)sender;
- (IBAction)ChangeYear:(id)sender;
- (IBAction)ChangeAtwork:(id)sender;
- (IBAction)ChangeAlbumArtist:(id)sender;
- (IBAction)ChangeAlbum:(id)sender;
- (IBAction)ChangeGenre:(id)sender;
@property (weak) IBOutlet NSScrollView *Table;

@property (weak) IBOutlet NSTextField *AlbumArtist;
@property (weak) IBOutlet NSTextField *Album;
@property (weak) IBOutlet NSComboBox *Genre;
@property (weak) IBOutlet NSTextField *Comments;
@property (weak) IBOutlet NSComboBox *Year;
@property (weak) IBOutlet NSScrollView *ListOfSongs;

@end
