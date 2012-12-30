//
//  Document.h
//  iDNA
//
//  Created by D_unknown on 12/25/12.
//  Copyright (c) 2012 D_unknown. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"
#import "Cell+Mutate.h"
@interface Document : NSDocument {
    NSMutableArray *population;
    Cell *goalDNA;
    
    NSInteger populationSize;
    NSInteger DNALength;
    NSInteger mutationRate;
        
    NSInteger generation;
    NSInteger bestMatch;
    BOOL paused;
    BOOL stopped;
    
    IBOutlet NSTextField *popSizeField;
    IBOutlet NSTextField *DNALenField;
    IBOutlet NSTextField *mutRateField;

    IBOutlet NSSlider *popSizeSlider;
    IBOutlet NSSlider *DNALenSlider;
    IBOutlet NSSlider *mutRateSlider;
   
    
    IBOutlet NSTextField *genLabel;
    IBOutlet NSTextField *bestMatchLabel;
    IBOutlet NSProgressIndicator *bestMatchProg;
    
    IBOutlet NSTextField *goalDNAField;
    
    IBOutlet NSButton *startBut;
    IBOutlet NSButton *loadBut;
    IBOutlet NSButton *stopBut;    

}

- (IBAction)startEvolution:(id)sender;
- (IBAction)populationSizeChange:(id)sender;
- (IBAction)DNALengthChange:(id)sender;
- (IBAction)mutationRateChange:(id)sender;
- (IBAction)stopEvol:(id)sender;


- (void) evolution;
- (void) setPopSize;
- (void) setDNALen;
- (void) setMutRate;
- (void) setGen;
- (void) setBestMatch;
- (void) createGoal;
@end
