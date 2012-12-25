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
#define MAXDNALENGTH 300;
#define DEFAULTMUTATIONRATE 1;


@interface AppDelegate : NSObject <NSApplicationDelegate, NSCoding> {
    NSInteger populationSize;
    NSInteger dnaLength;
    NSInteger mutationRate;
    Cell* goalDNA;  
    NSMutableArray* population;
    BOOL startEvolution;
    int generation;
    NSInteger bestHammingDistance;
    NSUndoManager* undoManager;
}
//@property (nonatomic,retain) NSUndoManager *undoManager;

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

@property (weak) IBOutlet NSTextField *bestMatchTextField;
@property (weak) IBOutlet NSTextField *generationTextField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

-(void)setVisible:(BOOL) v;


@end
