//
//  AppDelegate.h
//  PasteBoard
//
//  Created by Yuriy Ostapyuk on 11/19/12.
//  Copyright (c) 2012 Yuriy Ostapyuk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    NSMutableArray *pasteboardElements;

    NSPasteboard *pasteboard;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *tableView;


@end
