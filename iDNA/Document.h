//
//  Document.h
//  iDNA
//
//  Created by Igor Pavlov on 25.12.12.
//  Copyright (c) 2012 Igor Pavlov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Cell;

@interface Document : NSDocument
{
    Cell                *goalDna;
    NSMutableArray      *population;

    NSInteger           dnaLength;
    NSInteger           populationSize;
    NSInteger           mutationRate;
}

@property NSString*             goalDnaString;
@property (atomic) NSInteger    generationRound;
@property (atomic) double       bestDnaMatch;
@property (atomic) Boolean      evolutionStarted;
@property (atomic) Boolean      breakEvolution;


- (IBAction) onStartEvolution:(id)sender;
- (IBAction) onPause:(id)sender;
- (IBAction) onLoadGoalDna:(id)sender;

- (void)     evolutionMainMethod:(id)arg;

@end
