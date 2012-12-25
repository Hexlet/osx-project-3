//
//  LyricsWindowController.m
//  pTunes
//
//  Created by mindworm on 12/24/12.
//  Copyright (c) 2012 aquaxp. All rights reserved.
//

#import "LyricsWindowController.h"

@interface LyricsWindowController ()

@end

@implementation LyricsWindowController

-(id)init{
    return [super initWithWindowNibName:@"Lyrics"];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
-(void)changeLyricsText:(NSString*) text{
    [lyricsText insertText:text];
}

@end
