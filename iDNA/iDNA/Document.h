//
//  Document.h
//  iDNA
//
//  Created by Vadim Iskuchekov on 23.12.12.
//  Copyright (c) 2012 Llama on the Boat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"

@interface Document : NSDocument <NSTextFieldDelegate> {
    
    BOOL pause; 
  
    NSTextField *_popSize;
    NSTextField *_dnaLenght;
    NSTextField *_mutationRate;
    
    NSSlider *_popSizeSlider;
    NSSlider *_dnaLenghtSlider;
    NSSlider *_mutationRateSlider;
    
    NSTextField *_goalDna;
    
    NSTextField *_generation;
    NSTextField *_bestIndividualMatch;
    
    NSButton *_startEvolutionButton;
    NSButton *_loadGoalDnaButton;
    NSButton *_pauseButton;
    NSProgressIndicator *_bestMatchProgress;
    
    Cell *goalDNA;
    
    NSMutableArray *population; // популяция ДНК
    NSMutableArray *hammingDistatceForPopulation; // коэфиценты для данной популяции
}

- (void)createPopulationWithSize:(int)size andLenght:(int)lenght; // создание популяции
- (void)evolution; // эволюция
- (void)sortPopulation; // сортировка популяции
- (void)crossing; // скрещивание популяции 

- (IBAction)startEvolution:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)loadGoalDna:(id)sender;

@property (strong) IBOutlet NSTextField *popSize;
@property (strong) IBOutlet NSTextField *dnaLenght;
@property (strong) IBOutlet NSTextField *mutationRate;

@property (strong) IBOutlet NSSlider *popSizeSlider;
@property (strong) IBOutlet NSSlider *dnaLenghtSlider;
@property (strong) IBOutlet NSSlider *mutationRateSlider;

@property (strong) IBOutlet NSTextField *goalDna;

@property (strong) IBOutlet NSTextField *generation;
@property (strong) IBOutlet NSTextField *bestIndividualMatch;

@property (strong) IBOutlet NSButton *startEvolutionButton;
@property (strong) IBOutlet NSButton *loadGoalDnaButton;
@property (strong) IBOutlet NSButton *pauseButton;

@property (strong) IBOutlet NSProgressIndicator *bestMatchProgress;
@end
