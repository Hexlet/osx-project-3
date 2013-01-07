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
		
		dnaLength = 50;
		mutationRate = 50;
		populationSize = 5000;
	}
	
	return self;
}

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
	evolution = [[Evolution alloc] init];
	[self setGoalDNA];
}

- (IBAction)startEvolution:(id)sender
{
	[self setInputsEnabled:NO];
	[evolution setMutationRate:mutationRate];
	[evolution setPopulationSize:populationSize];
	[evolution setDnaLength:dnaLength];
	[evolution go];
}

- (IBAction)pause:(id)sender
{
	[self setInputsEnabled:YES];
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
