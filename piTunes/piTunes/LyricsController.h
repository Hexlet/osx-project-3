//
//  LyricsController.h
//  piTunes
//
//  Created by mindworm on 1/5/13.
//  Copyright (c) 2013 aquaxp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LyricsController : NSWindowController{
    NSString* lyrics;
}

@property (unsafe_unretained) IBOutlet NSTextView *lyricsTextView;
@property (weak) IBOutlet NSButton *buttonEdit;
@property (weak) IBOutlet NSButton *buttonDone;

- (void)updateLyrics:(NSString *)text;
- (IBAction)editLyrics:(id)sender;
- (IBAction)commitLyrics:(id)sender;

@end
