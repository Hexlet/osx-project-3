//
//  AppDelegate.m
//  iDNA
//
//  Created by n on 25.12.12.
//  Copyright (c) 2012 witzawitz. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (id) init
{
	if (self = [super init])
	{
		DNAlength = 50;
		mutationRate = 50;
		populationSize = 5000;
	}
	
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void) setPopulationSize: (NSInteger) x
{
	[_tfPopulationSize setStringValue:[NSString stringWithFormat:@"%ld", x]];
	populationSize = x;
}

- (void) setDNAlength: (NSInteger) x
{
	[_tfDNAlength setStringValue:[NSString stringWithFormat:@"%ld", x]];
	DNAlength = x;
}

- (void) setMutationRate: (NSInteger) x
{
	[_tfMutationRate setStringValue:[NSString stringWithFormat:@"%ld", x]];
	mutationRate = x;
}

@end
