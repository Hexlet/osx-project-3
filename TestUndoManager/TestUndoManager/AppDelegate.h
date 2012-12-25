//
//  AppDelegate.h
//  TestUndoManager
//
//  Created by Sergey on 24.12.12.
//  Copyright (c) 2012 Sergey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSInteger testNum;
    NSUndoManager* undo;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *numTextField;

@end
