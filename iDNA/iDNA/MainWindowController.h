//
//  MainWindowController.h
//  iDNA
//
//  Created by Tolya on 25.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Cell;

@interface MainWindowController : NSWindowController

@property int populationSize;
@property int dnaLength;
@property int mutationRate;
@property (readonly) Cell *goalDNA;
@property (readonly) BOOL isEvolutionPaused;
@property NSUInteger generation;
@property int bestMatch;

- (IBAction)loadGoalDNA:(id)sender;
- (IBAction)startEvolution:(id)sender;
- (IBAction)pauseEvolution:(id)sender;

@end
