//
//  PreferencesWindowController.m
//  pTunes
//
//  Created by mindworm on 12/23/12.
//  Copyright (c) 2012 aquaxp. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()

@end

@implementation PreferencesWindowController

-(id)init{
    return [super initWithWindowNibName:@"Preferences"];
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
}

-(IBAction)changeShowInfo:(id)sender{
}

@end
