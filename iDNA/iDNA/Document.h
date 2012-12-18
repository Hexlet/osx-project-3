//
//  Document.h
//  iDNA
//
//  Created by Александр Борунов on 13.12.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Evolution.h"

#define iDNADocumentType @"ru.daugava.idna.document"
#define iDNAExtension @"dna"

#define kPopulationSize @"populationSize"
#define kDNALength      @"dnaLength"
#define kMutationRate   @"mutationRate"
#define kGoalDNA        @"goalDNA"
#define kEvolution      @"evolution"

#define btnStatusStart  1
#define btnStatusPause  2
#define btnStatusRelease 3

@interface Document : NSDocument {
    NSInteger populationSize;
    NSInteger dnaLength;
    NSInteger mutationRate;
    NSString *goalDNA;
    
    NSInteger bestMatchPercent;
    NSInteger generation;
    BOOL continueEvolution;
    NSInteger statusEvolution;
    Evolution *evolution;

    NSArray *disabledWhenIncorrectDNA;
    NSArray *disabledWhenEvolution;
    
    
}


@property (weak) IBOutlet NSTextField *fieldPopulationSize;
@property (weak) IBOutlet NSTextField *fieldDNALength;
@property (weak) IBOutlet NSTextField *fieldMutationRate;

@property (weak) IBOutlet NSSlider *sliderPopulationSize;
@property (weak) IBOutlet NSSlider *sliderDNALength;
@property (weak) IBOutlet NSSlider *sliderMutationRate;


@property (weak) IBOutlet NSTextField *fieldGenerationNumber;
@property (weak) IBOutlet NSTextField *fieldBestMatch;
@property (weak) IBOutlet NSLevelIndicator *indicatorBestMatch;

@property (weak) IBOutlet NSTextField *fieldIsDNAcorrect;

@property (weak) IBOutlet NSTextField *fieldGoalDNA;

@property (weak) IBOutlet NSButton *buttonLoadGoalDNA;

@property (weak) IBOutlet NSButton *buttonStart;
@property (weak) IBOutlet NSButton *buttonPause;
@property (weak) IBOutlet NSButton *buttonLoad;
@property (weak) IBOutlet NSButton *buttonStep;

- (IBAction)validateDNA:(id)sender;
- (IBAction)buttonStartPressed:(id)sender;
- (IBAction)buttonPausePressed:(id)sender;
- (IBAction)buttonStepPressed:(id)sender;
- (IBAction)buttonPrintpressed:(id)sender;

@end
