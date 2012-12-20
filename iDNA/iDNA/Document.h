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


#define btnStatusStart  @"Start Evolution"
#define btnStatusPause  @"Pause Evolution"
#define btnStatusResume @"Resume Evolution"


@interface Document : NSDocument {
    NSInteger populationSize;
    NSInteger dnaLength;
    NSInteger mutationRate;
    NSString *goalDNA;
    NSInteger bestMatchPercent;

    BOOL continueEvolution;
    Evolution *evolution;

    NSArray *disabledWhenIncorrectDNA;
    NSArray *disabledWhenEvolution;
    
    NSEvent *myEvent;
}

@property NSInteger docID;

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



@property (weak) IBOutlet NSButton *buttonStart;
@property (weak) IBOutlet NSButton *buttonNew;
@property (weak) IBOutlet NSButton *buttonPrint;


- (IBAction)validateDNA:(id)sender;

- (IBAction)buttonStartPressed:(id)sender;
- (IBAction)buttonPrintpressed:(id)sender;
- (IBAction)buttonNewPressed:(id)sender;


-(void)doing;

@end
