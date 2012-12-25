//
//  LyricsWindowController.h
//  pTunes
//
//  Created by mindworm on 12/24/12.
//  Copyright (c) 2012 aquaxp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LyricsWindowController : NSWindowController{
    IBOutlet NSTextView* lyricsText;
}
-(void)changeLyricsText:(NSString*) text;

@end
