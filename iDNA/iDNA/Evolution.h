//
//  Evolution.h
//  iDNA
//
//  Created by n on 06.01.13.
//  Copyright (c) 2013 witzawitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@interface Evolution : NSObject
{
	NSInteger step;
	Boolean finished;
	Boolean started;
	
	NSInteger mutationRate;
	NSMutableArray *population;
	Cell *goalDNA;
}

-(Cell *) createGoalDNAWithLength:(NSInteger) length;
-(void) creatPopulationWithSize:(NSInteger) populationSize andDNALength:(NSInteger) dnaLength;

@end
