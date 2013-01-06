//
//  Document.h
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 03.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Population.h"
#import "Cell.h"

static void *RMDocumentKVOContext;

@interface Document : NSDocument <NSCoding>

@property NSUInteger populationSize, dnaLength, mutationRate;
@property Population * myPopulation;
@property Cell * goalDna;
@property NSString * evolutionStatus;
@property NSThread * evolutionThread;
@property (weak) IBOutlet NSTextField *populationSizeTxtFld;
@property (weak) IBOutlet NSSlider *populationSizeHSldr;
@property (weak) IBOutlet NSTextField *dnaLengthTxtFld;
@property (weak) IBOutlet NSSlider *dnaLengthHSldr;
@property (weak) IBOutlet NSTextField *mutationRateTxtFld;
@property (weak) IBOutlet NSSlider *mutationRateHSldr;

@property (unsafe_unretained) IBOutlet NSTextView *goalDnaTxtVw;

@property (weak) IBOutlet NSButton *loadGoalDnaBtn;
@property (weak) IBOutlet NSButton *startEvolutionBtn;
@property (weak) IBOutlet NSButton *pauseBtn;

- (IBAction)loadGoalDna:(id)sender;
- (IBAction)startEvolution:(id)sender;
- (IBAction)pauseEvolution:(id)sender;

@property (weak) IBOutlet NSTextField *generationTxtLbl;
@property (weak) IBOutlet NSTextField *bestMatchTxtLbl;
@property (weak) IBOutlet NSTextField *bestCellsTxtLbl;



- (void)generateGoalDna;
- (void)displayGoalDna:(NSString *)dna;
- (void)generatePopulation;
- (void)resetAppControlsAccordingEvolutionStatus;
- (void)runEvolution;
- (void)enableAppControls:(BOOL)status;

@end
