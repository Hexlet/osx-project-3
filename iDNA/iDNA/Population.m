//
//  Population.m
//  iDNA
//
//  Created by Anatoliy Dudarchuk on 25.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "Population.h"
#import "Cell.h"
#import "Cell+mutator.h"

@interface Population () {
    NSUInteger _size;
    NSMutableArray *_items;
    Cell *_goalDNA;
}

@end

@implementation Population

- (id)initWithSize:(NSUInteger)size goalDNA:(Cell *)goalDNA
{
    if (self = [super init]) {
        _size = size;
        _goalDNA = goalDNA;
    }
    
    return self;
}

- (NSArray *)items
{
    return _items;
}

- (void)generateWithDNALength:(NSUInteger)dnaLength
{
    _items = [[NSMutableArray alloc] initWithCapacity:_size];
    for (NSInteger i = 0; i < _size; i++) {
        Cell *dna = [[Cell alloc] initWithLength:dnaLength];
        [dna createDNA];
        
        [_items addObject:dna];
    }
}

- (void)sort
{
    NSComparator dnaSortBlock = ^(Cell *cell1, Cell *cell2) {
        int d1 = [cell1 hammingDistance:_goalDNA];
        int d2 = [cell2 hammingDistance:_goalDNA];
        
        if (d1 == d2)
            return NSOrderedSame;
        return d1 < d2 ? NSOrderedAscending : NSOrderedDescending;
    };
    NSArray *sortedPopulation = [_items sortedArrayUsingComparator:dnaSortBlock];
    _items = [[NSMutableArray alloc] initWithArray:sortedPopulation];
}

- (BOOL)isMatch
{
    for (Cell *dna in _items) {
        if ([dna hammingDistance:_goalDNA] == 0) {
            return YES;
        }
    }
    
    return NO;
}

- (void)makeCrossing
{
    if ([_items count] < 2)
        return;
    
    int maxIndex = [_items count] / 2 - 1;
    int index1 = arc4random_uniform(maxIndex);
    int index2 = arc4random_uniform(maxIndex);
    Cell *dna1 = [_items objectAtIndex:index1];
    Cell *dna2 = [_items objectAtIndex:index2];
    int crossKind = arc4random_uniform(2);
    Cell *newDna = [dna1 makeCrossingWithDNA:dna2 usingCrossKind:crossKind];
    
    for (NSUInteger i = maxIndex + 1; i < [_items count]; i++) {
        [_items replaceObjectAtIndex:i withObject:[newDna copy]];
    }
}

- (void)mutateWithPercentOfMutation:(NSUInteger)percent
{
    for (Cell *dna in _items) {
        [dna mutate:percent];
    }
}

@end
