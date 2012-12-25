//
//  AppDelegate.h
//  project3
//
//  Created by VITALIY NESTERENKO on 24.12.12.
//  Copyright (c) 2012 VITALIY NESTERENKO. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"
#import "Population.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *generationNumber;
@property (weak) IBOutlet NSTextField *populationSizeField;

@property (weak) IBOutlet NSTextField *dnaLengthField;
@property (weak) IBOutlet NSTextField *mutationRateField;

@property (weak) IBOutlet NSTextField *bestMatch;
@property (weak) IBOutlet NSTextField *goalDNAField;
@property (weak) IBOutlet NSProgressIndicator *progressBar;



@property Population *population;
@property int populationSize;
@property int dnaLength;
@property int mutationRate;
@property int progress;
@property int distanceToTarget;
@property int generationCount;
@property BOOL isEvolutionOver;
@property NSString *goalDNA;


- (IBAction)startEvolution:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)loadDNA:(id)sender;


-(void) initPopulation;

@end
