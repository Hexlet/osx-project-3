//
//  Document.h
//  DNASecond
//
//  Created by Tsyganov Stanislav on 23.12.12.
//  Copyright (c) 2012 Tsyganov Stanislav. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell+mutator.h"

@interface Document : NSDocument{

}

@property (nonatomic) NSInteger popSize;
@property (nonatomic) NSInteger dnaLength;
@property (nonatomic) NSInteger mutRateSize;

@property (nonatomic) NSInteger generation;

@property (nonatomic, retain) NSString* stringForPerfectCell;
@property (nonatomic, retain) NSMutableArray* dnasArray;
@property (nonatomic) BOOL evolutionStopped;




@property (weak) IBOutlet NSTextFieldCell *perfectCellTextField;
@property (weak) IBOutlet NSProgressIndicator *progressBar;
@property (weak) IBOutlet NSButton *strtEvolutionBtn;
@property (weak) IBOutlet NSButton *pauseEvolutionBtn;
@property (weak) IBOutlet NSTextField *popSizeTextField;
@property (weak) IBOutlet NSTextField *dnaLengthTextField;
@property (weak) IBOutlet NSSlider *popSizeSlider;
@property (weak) IBOutlet NSSlider *dnaLengthSlider;
@property (weak) IBOutlet NSTextField *generationLabel;
@property (weak) IBOutlet NSTextField *bestMatchLabel;
@property (weak) IBOutlet NSTextField *averageHammingDistLabel;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;





- (IBAction)startEvolution:(id)sender;
- (IBAction)stopEvolution:(id)sender;

@end
