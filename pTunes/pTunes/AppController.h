//
//  AppController.h
//  pTunes
//
//  Created by mindworm on 12/23/12.
//  Copyright (c) 2012 aquaxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LyricsWindowController;
@class PreferencesWindowController;

@interface AppController : NSObject{
    LyricsWindowController *lyrics;
    PreferencesWindowController *preferences;
}
-(IBAction)showPreferencesPanel:(id)sender;
-(IBAction)showLyricsWindow:(id)sender;

@end
