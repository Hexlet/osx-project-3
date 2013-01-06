//
//  Population.m
//  iDNA
//
//  Created by Администратор on 1/6/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "Population.h"

@implementation Population

- (id) initWithSize:(int)size andDNALength: (int)l andGoalDNA:(Cell *)gDNA {
    if (self = [super init]) {
        _population = [[NSMutableArray alloc] initWithCapacity: size];
		goalDNA = gDNA;
        for (int i = 0; i < size; i++) {
			Cell *c = [[Cell alloc] initWithLength: l];
            [_population addObject: c];
        }
    }
    return self;
}

-  (void) removeAllPopulation {
	[_population removeAllObjects];
}

- (void) sortToGoalDNA {
	//NSLog(@"Population before sorting: %@", [self description]);
	[_population sortUsingComparator:^(Cell *a, Cell *b) {
		int d1 = [a hammingDistance: goalDNA];
		int d2 = [b hammingDistance: goalDNA];					
		if (d1 > d2) return (NSComparisonResult)NSOrderedDescending;
		if (d2 > d1) return (NSComparisonResult)NSOrderedAscending;
		return (NSComparisonResult)NSOrderedSame;
	}];
	//NSLog(@"Population afther sorting: %@", [self description]);
}

- (void) crossPopulationTopPercent:(int) p {
	if (p < 0 || p > 100) {
		NSLog(@"Incorrect percent for population crossing");
		return;
	} else {
		int cellsCountInBestPart = p * [_population count] / 100;
		int cellsCountInWorsePart = (int)[_population count] - cellsCountInBestPart;
		
		// проверка есть ли в каждой из частей как минимум один член
		if (cellsCountInBestPart == 0 || cellsCountInWorsePart == 0) {
			NSLog(@"Population is too small for crossing");
			return;
		}
		
		int shot1, shot2;
		Cell *c1,*c2;
		for (int i = 0; i < cellsCountInWorsePart; i++){
			// берем 2 случайные особи из лучших
			shot1 = arc4random() % cellsCountInBestPart;
			shot2 = arc4random() % cellsCountInBestPart;
			c1 = [_population objectAtIndex:shot1];
			c2 = [_population objectAtIndex:shot2];
			// заменяем особь из худших на результат скрещивания
			[_population replaceObjectAtIndex:i + cellsCountInBestPart withObject:[Cell Cell1:c1 crossWithCell2:c2]];
		}
	}
}

- (void) mutate:(int) x {
	for (int i = 0; i < [_population count]; i++) {
		[[_population objectAtIndex:i] mutate:x];
	}
}

- (NSString*) description {
	NSMutableString *result = [[NSMutableString alloc] init];
	int distance;
	
	for (int i = 0; i < [_population count]; i++) {
		distance = [[_population objectAtIndex:i] hammingDistance:goalDNA];
		[result appendString:[NSString stringWithFormat:@"%i, ", distance]];
	}
	return result;
}

@end
