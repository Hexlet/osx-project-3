//
//  Cell.m
//  Project3
//
//  Created by Bogdan Pankiv on 12/24/12.
//  Copyright (c) 2012 Bogdan Pankiv. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id) init
{
    self = [super init];
    if (!self) return self;
    
    srandomdev();
    dnaLength = 100;
    
    dna = [[NSMutableArray alloc] init];
    for (int i=0; i<dnaLength; ++i)
        [dna addObject: [[NSNumber alloc] initWithInt: random()%4] ];
    
    return self;
}

-(id) initWithDnaLength: (int) x
{
    self = [super init];
    if (!self) return self;
    dnaLength = x;
    
    dna = [[NSMutableArray alloc] init];
    for (int i=0; i<dnaLength; ++i)
        [dna addObject: [[NSNumber alloc] initWithInt: random()%4] ];
    return self;
}

-(id) initWithCell:(Cell *)cell
{
    self = [super init];
    if (!self) return self;

    dna = [[NSMutableArray alloc] init];
    dnaLength = cell->dnaLength;
    for (int i=0; i<cell->dnaLength; ++i)
        [dna addObject: [cell getDnaAtPosition:i] ];
    return self;
}

-(int) hammingDistance:(Cell *)cell
{
    int distance = 0;
    for (int i=0; i<dnaLength; ++i) {
        if ([self getDnaAtPosition:i] != [cell getDnaAtPosition:i]) ++distance;
    }
    return distance;
}

-(NSNumber *) getDnaAtPosition:(int)pos
{
    if (pos<0 || pos>dnaLength-1) return NULL;
    return dna[pos];
}

-(NSString *) print
{
    NSArray *values = [NSArray arrayWithObjects:@"A", @"T", @"G", @"C", nil];
    NSString *result = [[NSString alloc] init];
    for (int i=0; i<dnaLength; ++i)
        result = [result stringByAppendingString: values[ [dna[i] intValue] ] ];
    
    return result;
}
@end
