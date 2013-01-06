//
//  iDNADocument.h
//  iDNA
//
//  Created by Администратор on 1/5/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"
#import "Population.h"

@interface iDNADocument : NSDocument {
	Cell *goalDNA;
	Population *p;
	
	int populationSize;
	int DNALength;
	int mutationRate;
}

@property (weak) IBOutlet NSTextField *populationSizeText;
@property (weak) IBOutlet NSTextField *DNALengthText;
@property (weak) IBOutlet NSTextField *mutationRateText;

@property (weak) IBOutlet NSSlider *populationSizeSlider;
@property (weak) IBOutlet NSSlider *DNALengthSlider;
@property (weak) IBOutlet NSSlider *mutationRateSlider;

@property (weak) IBOutlet NSTextField *generation;
@property (weak) IBOutlet NSTextField *overallBestMatch;
@property (weak) IBOutlet NSTextField *bestMatch;

@property (weak) IBOutlet NSTextField *goalDNAText;

@property (weak) IBOutlet NSButton *startEvolution;
@property (weak) IBOutlet NSButton *pause;
@property (weak) IBOutlet NSButton *loadGoalDNA;

- (IBAction)startEvolutionClicked:(NSButton *)sender;
- (IBAction)pauseClicked:(NSButton *)sender;
- (IBAction)loadGoalDNAClicked:(NSButton *)sender;

@end
