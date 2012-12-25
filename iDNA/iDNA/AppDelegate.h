//
//  AppDelegate.h
//  iDNA
//
//  Created by n on 25.12.12.
//  Copyright (c) 2012 witzawitz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSInteger populationSize;
	NSInteger DNAlength;
	NSInteger mutationRate;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *tfPopulationSize;
@property (weak) IBOutlet NSTextField *tfDNAlength;
@property (weak) IBOutlet NSTextField *tfMutationRate;

@end
