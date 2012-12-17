//
//  YKAppDelegate.h
//  iDNA
//
//  Created by Yuri Kirghisov on 12.12.12.
//  Copyright (c) 2012 Yuri Kirghisov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YKDNA.h"

@interface YKAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSTextField *populationSizeTextField;
    IBOutlet NSTextField *dnaLengthTextField;
    IBOutlet NSTextField *mutationRateTextField;

    IBOutlet NSProgressIndicator *evolutionProgressIndicator;
}

@property (assign) IBOutlet NSWindow *window;

@property NSUInteger populationSize;
@property NSUInteger dnaLength;
@property NSUInteger mutationRate;

@property (retain) YKDNA *goalDNA;
@property (retain) NSMutableArray *population;

@property BOOL isBusy;

- (IBAction)startEvolutionButtonPressed:(id)sender;
- (IBAction)pauseButtonPressed:(id)sender;
- (IBAction)loadGoalDnaButtonPressed:(id)sender;

@end
