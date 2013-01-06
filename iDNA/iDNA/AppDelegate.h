//
//  AppDelegate.h
//  iDNA
//
//  Created by n on 25.12.12.
//  Copyright (c) 2012 witzawitz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSInteger populationSize;
	NSInteger dnaLength;
	NSInteger mutationRate;
	
	Cell *goalDNA;
}

- (void) createGoalDNA;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *tfGoalDNA;

@end
