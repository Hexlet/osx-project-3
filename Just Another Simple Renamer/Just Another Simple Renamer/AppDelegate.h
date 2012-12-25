//
//  AppDelegate.h
//  Just Another Simple Renamer
//
//  Created by Администратор on 12/20/12.
//  Copyright (c) 2012 Nope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    NSMutableArray *ResultFileNames, *SourceFilesArray;
}

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *PrefixName;
@property (weak) IBOutlet NSTextField *CounterMask;
@property (weak) IBOutlet NSTextField *CounterStartFrom;
@property (weak) IBOutlet NSTableView *SourceTableView;
@property (weak) IBOutlet NSTableView *ResultTableView;

- (IBAction)addFiles:(id)sender;
- (IBAction)addFolder:(id)sender;
- (IBAction)clearList:(id)sender;
- (IBAction)goRename:(id)sender;

@end
