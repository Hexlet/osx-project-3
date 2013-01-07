//
//  Evolution.h
//  iDNA
//
//  Created by n on 06.01.13.
//  Copyright (c) 2013 witzawitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

#define INIT		0
#define STARTED		1
#define FINISHED	2
#define PAUSED		3

@interface Evolution : NSObject
{
	NSInteger step;
	NSInteger state;
	
	NSInteger mutationRate;
	NSInteger populationSize;
	NSInteger dnaLength;
	NSMutableArray *population;
	Cell *goalDNA;
}

-(Cell *) createGoalDNAWithLength:(NSInteger) length;
-(void) setMutationRate: (NSInteger) rate;
-(void) setPopulationSize: (NSInteger) size;
-(void) setDnaLength: (NSInteger) length;
-(void) go;

@end
