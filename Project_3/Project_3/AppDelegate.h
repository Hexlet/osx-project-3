//
//  AppDelegate.h
//  Project_3
//
//  Created by Admin on 12/23/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Configuration.h"
#import "Cell.h"
#import "Cell+mutator.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *populationSizeField;
@property (weak) IBOutlet NSSlider *populationSizeSlider;
@property (weak) IBOutlet NSTextField *dnaLenField;
@property (weak) IBOutlet NSSlider *dnaLenSlider;
@property (weak) IBOutlet NSTextField *mutRateField;
@property (weak) IBOutlet NSSlider *mutRateSlider;
@property (weak) IBOutlet NSTextField *goalDnaText;
@property (weak) IBOutlet NSButton *loadDna;
@property (weak) IBOutlet NSButton *start;
@property (weak) IBOutlet NSButton *pause;
@property (strong) Configuration *conf;
@property (strong) Cell *goalDNA;
@property (strong) NSMutableArray *population;
@property (assign) bool pauseEvol;


- (IBAction)populationSizeChanged:(id)sender;
- (IBAction)dnaLengthChanged:(id)sender;
- (IBAction)mutRateChanged:(id)sender;
- (IBAction)startEvolution:(id)sender;
- (IBAction)pauseEvolution:(id)sender;
- (void)evolution;

@end
