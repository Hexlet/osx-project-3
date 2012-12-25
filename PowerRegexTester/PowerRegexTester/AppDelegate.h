//
//  AppDelegate.h
//  PowerRegexTester
//
//  Created by Igor on 18/11/2012.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OptionsMatrix.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet OptionsMatrix *options;
@property (weak) IBOutlet NSTextField *pattern;
@property (assign) IBOutlet NSTextView *sourceView;

@property (weak) IBOutlet NSTextField *url;
@property (weak) IBOutlet NSProgressIndicator *loadProgress;
@property (weak) IBOutlet NSTableView *resultsTableView;
@property (weak) IBOutlet NSTextField *statusText;

@end
