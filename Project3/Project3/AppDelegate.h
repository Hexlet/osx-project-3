//
//  AppDelegate.h
//  Project3
//
//  Created by Bogdan Pankiv on 12/24/12.
//  Copyright (c) 2012 Bogdan Pankiv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"
#import "Cell+mutator.h"
#import "Cell+crosser.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSInteger populationSize;
    NSInteger dnaLength;
    NSInteger mutationRate;
    Cell *goaldna;
    NSInteger pause;
    NSMutableArray *population;
    NSInteger generation;
}

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *PopulationSizeInput;
@property (weak) IBOutlet NSTextField *DnaLengthInput;
@property (weak) IBOutlet NSTextField *MutationRateInput;
@property (weak) IBOutlet NSTextFieldCell *GoalDnaInput;
@property (weak) IBOutlet NSTextField *GenerationLabel;
@property (weak) IBOutlet NSTextField *BestMatchLabel;


- (IBAction)StartEvolution:(id)sender;
- (IBAction)PauseEvolution:(id)sender;
- (IBAction)LoadDNA:(id)sender;

-(void)process;
-(void)sortPopulation;
-(void)crossPopulation;
-(void)mutatePopulation;

@end
