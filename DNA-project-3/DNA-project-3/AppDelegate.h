//
//  AppDelegate.h
//  DNA-project-3
//
//  Created by Sergey on 22.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"

#define DEFAULTPOPULATIONSIZE 100;
#define DEFAULTDNALENGTH 50;
#define DEFAULTMUTATIONRATE 1;


@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSInteger populationSize;
    NSInteger dnaLength;
    NSInteger mutationRate;
    Cell* goalDNA;  
    NSMutableArray* population;
}
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *goalDNATextField;

@property (weak) IBOutlet NSButton *pauseButton;
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *loadButton;

@property (weak) IBOutlet NSTextField *populationSizeTextField;
@property (weak) IBOutlet NSTextField *dnaLengthTextField;
@property (weak) IBOutlet NSTextField *mutationRateTextField;

@property (weak) IBOutlet NSSlider *populationSizeSlider;
@property (weak) IBOutlet NSSlider *dnaLengthSlider;
@property (weak) IBOutlet NSSlider *mutationRateSlider;

- (IBAction)startEvolution:(id)sender;
- (IBAction)pauseEvolution:(id)sender;
- (IBAction)loadGoalDNA:(id)sender;

@end
