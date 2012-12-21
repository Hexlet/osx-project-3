//
//  AppDelegate.h
//  timer
//
//  Created by Максим on 20.11.12.
//  Copyright (c) 2012 CarelessApps. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSButton *restButton;
    IBOutlet NSButton *workButton;
    NSTimer *restTimer;
    NSTimer *workTimer;
    IBOutlet NSTextField *restLable;
    IBOutlet NSTextField *workLable;
    IBOutlet NSTextField *summ;
    IBOutlet NSTextField *restPersent;
    IBOutlet NSTextField *workPersent;
}

@property (assign) IBOutlet NSWindow *window;

-(IBAction)work:(id)sender;
-(IBAction)rest:(id)sender;

-(void)drawPie:(NSColor *)rest:(NSColor *)work;

@end
