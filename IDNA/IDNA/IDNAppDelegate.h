//
//  IDNAppDelegate.h
//  IDNA
//
//  Created by Dmitriy Zhukov on 06.01.13.
//  Copyright (c) 2013 Dmitriy Zhukov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IDNCell;
@class IDNPopulation;

@interface IDNAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property NSInteger populationSize;
@property NSInteger DNALength;
@property NSInteger mutationRate;
@property NSInteger generationCount;
@property NSInteger distanceToTargetDNA;
@property NSInteger progress;

@property IDNCell* goalDNA;
@property (weak) IBOutlet NSTextField *goalDNAField;

@property IDNPopulation* workingPopulation;

@property BOOL interfaceStatement;
@property BOOL startStatement;
@property BOOL pauseStatement;
@property BOOL pauseEvolutionFlag;
@property BOOL stopEvolutionFlag;


- (IBAction)loadDNAfromFile:(id)sender;
- (IBAction)saveData:(id)sender;
- (IBAction)startEvolution:(id)sender;
- (IBAction)pauseEvolution:(id)sender;
- (IBAction)stopEvolution:(id)sender;

@end
