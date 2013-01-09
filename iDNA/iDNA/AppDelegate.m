//
//  AppDelegate.m
//  iDNA
//
//  Created by n on 25.12.12.
//  Copyright (c) 2012 witzawitz. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
	NSInteger maxPopulationSize;
	NSInteger maxDnaLength;
	NSInteger maxMutationRate;
}

- (id) init
{
	if (self = [super init])
	{
		maxDnaLength = 100;
		maxMutationRate = 100;
		maxPopulationSize = 10000;
		
		dnaLength = maxDnaLength / 2;
		mutationRate = maxMutationRate / 2;
		populationSize = maxPopulationSize / 2;
	}
	
	return self;
}

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[_slDnaLength setIntegerValue:dnaLength];
	[_slMutationRate setIntegerValue:mutationRate];
	[_slPopulationSize setIntegerValue:populationSize];
	
	evolution = [[Evolution alloc] init];
	[self setGoalDNA];
	[self addObserver:self forKeyPath:@"dnaLength" options:NSKeyValueObservingOptionNew context:nil];
	[self addObserver:self forKeyPath:@"mutationRate" options:NSKeyValueObservingOptionNew context:nil];
	[self addObserver:self forKeyPath:@"populationSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// If any of parameters was changed we should reset evolution.
	[evolution reset];
	[self setLabelForGeneration:0];
	[self setLabelForBestMatch:dnaLength];
}

-(void) dealloc
{
	[self removeObserver:self forKeyPath:@"dnaLength"];
	[self removeObserver:self forKeyPath:@"mutationRate"];
	[self removeObserver:self forKeyPath:@"populationSize"];
}

- (IBAction)startEvolution:(id)sender
{
	[self performSelectorInBackground:@selector(evolve) withObject:nil];
}

// Evolve in background.
-(void) evolve
{
	[self setInputsEnabled:NO];

	if ([evolution state] == INIT)
		[evolution initWithMutationRate:mutationRate PopulationSize:populationSize DnaLength:dnaLength];
	else if ([evolution state] == PAUSED)
		[evolution setState:STARTED];
	
	while ([evolution state] == STARTED)
	{
		[evolution perfomStep];
		[self setLabelForGeneration:[evolution step]];
		[self setLabelForBestMatch:[evolution bestHammingDistance]];
	}
	[self setInputsEnabled:YES];
}

// Pause button pressed.
- (IBAction)pause:(id)sender
{
	[evolution setState:PAUSED];
	[self setInputsEnabled:YES];
}

-(void) setLabelForGeneration: (NSInteger) step
{
	[_lbGeneration setStringValue:[NSString stringWithFormat:@"%ld", step]];
}

-(void) setLabelForBestMatch: (NSInteger) hammingDistance
{
	[_lbBestMatch setStringValue:[NSString stringWithFormat:@"%ld", 100 - 100 * hammingDistance / dnaLength]];
}

- (void) setInputsEnabled: (Boolean) status
{
	[_btLoadGoalDNA setEnabled:status];
	[_btStartEvolution setEnabled:status];
	[_btPause setEnabled:!status];
	
	[_tfDnaLength setEnabled:status];
	[_tfMutationRate setEnabled:status];
	[_tfPopulationSize setEnabled:status];
	
	[_slDnaLength setEnabled:status];
	[_slMutationRate setEnabled:status];
	[_slPopulationSize setEnabled:status];
}

// Create new goal DNA and sets value to corresponding text field.
- (void) setGoalDNA
{
	[_tfGoalDNA setStringValue:[[evolution createGoalDNAWithLength:dnaLength] DNAtoString]];
}

// Getters.
- (NSInteger) dnaLength			{ return dnaLength; }
- (NSInteger) mutationRate		{ return mutationRate; }
- (NSInteger) populationSize	{ return populationSize; }

// Setters.
- (void) setDnaLength: (NSInteger) x
{
	dnaLength = MIN(x, maxDnaLength);
	[_tfDnaLength setStringValue:[NSString stringWithFormat:@"%ld", dnaLength]];
	[self setGoalDNA];
}

- (void) setMutationRate: (NSInteger) x
{
	mutationRate = MIN(x, maxMutationRate);
	[_tfMutationRate setStringValue:[NSString stringWithFormat:@"%ld", mutationRate]];
}

- (void) setPopulationSize: (NSInteger) x
{
	populationSize = MIN(x, maxPopulationSize);
	[_tfPopulationSize setStringValue:[NSString stringWithFormat:@"%ld", populationSize]];
}
@end
