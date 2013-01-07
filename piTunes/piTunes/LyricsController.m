//
//  LyricsController.m
//  piTunes
//
//  Created by mindworm on 1/5/13.
//  Copyright (c) 2013 aquaxp. All rights reserved.
//

#import "LyricsController.h"

@interface LyricsController ()

@end

@implementation LyricsController

- (id)init{
    lyrics = @"no lyrics";
    return [super initWithWindowNibName:@"Lyrics"];
}

- (void)updateLyrics:(NSString *)text{
    lyrics = text;
    //if (lyrics == @""){ lyrics = @"No lyrics";}
    [_lyricsTextView setTextColor:[NSColor whiteColor]];
    [_lyricsTextView setString:lyrics];
}

- (IBAction)editLyrics:(id)sender {
    if([_buttonEdit title] == @"Edit"){
        [_buttonEdit setTitle:@"Cancel"];
        [_lyricsTextView setEditable:YES];
        [_buttonDone setHidden:NO];
    }
    else{
        [_buttonEdit setTitle:@"Edit"];
        [_lyricsTextView setEditable:NO];
        [self updateLyrics:lyrics];
        [_buttonDone setHidden:YES];
    }
}

- (IBAction)commitLyrics:(id)sender {
    [_buttonEdit setTitle:@"Edit"];
    [_lyricsTextView setEditable:NO];
    [_buttonDone setHidden:YES];
    
    [self updateLyrics:lyrics];
    
    
}
-(void)showWindow:(id)sender{
    [super showWindow:sender];
}

@end
