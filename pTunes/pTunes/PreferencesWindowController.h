//
//  PreferencesWindowController.h
//  pTunes
//
//  Created by mindworm on 12/23/12.
//  Copyright (c) 2012 aquaxp. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const PTshowInfoKey;

@interface PreferencesWindowController : NSWindowController{
    IBOutlet NSButton* showInfo;
}

-(IBAction)changeShowInfo:(id)sender;

@end
