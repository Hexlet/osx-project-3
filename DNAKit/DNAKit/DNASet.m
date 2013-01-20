//
//  DNASet.m
//  DNAKit
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNASet.h"


@implementation DNASet
{
    NSMutableArray *dnas;
    BOOL sorted;
}

- (id)initWithDNALength:(NSUInteger)length capacity:(NSUInteger)capacity
{
    if (self = [super init]) {
        dnas = [NSMutableArray arrayWithCapacity:capacity];
        for (NSUInteger i = 0; i < capacity; ++i) {
            [dnas addObject:[[DNA alloc] initWithLength:length]];
        }
        sorted = NO;
    }
    return self;
}

- (void)evolve
{
    if (!sorted) {
        [self sort];
    }
    NSUInteger topCount = [dnas count] / 2;
    for (NSUInteger i = topCount; i < [dnas count]; ++i) {
        NSUInteger indexA = arc4random() % topCount;
        NSUInteger indexB = (indexA + 1 + arc4random() % (topCount - 1)) % topCount;
        [dnas setObject:[DNA crossoverDNA:[dnas objectAtIndex:indexA] withDNA:[dnas objectAtIndex:indexB]] atIndexedSubscript:i];
    }
    
    for (NSUInteger i = 0; i < [dnas count]; ++i) {
        [[dnas objectAtIndex:i] mutate:_mutatePercent];
    }
    [self sort];
}

- (void)sort
{
    _minDistance = NSUIntegerMax;
    [dnas sortUsingComparator:^(id dnaA, id dnaB) {
        NSUInteger distance = [(DNA *)dnaA distanceToDNA:_goalDNA];
        if (distance < _minDistance)
            _minDistance = distance;
        NSNumber *distanceA = [NSNumber numberWithUnsignedLong:distance];
        distance = [(DNA *)dnaB distanceToDNA:_goalDNA];
        if (distance < _minDistance)
            _minDistance = distance;
        NSNumber *distanceB = [NSNumber numberWithUnsignedLong:distance];
        return [distanceA compare:distanceB];
    }];
    sorted = YES;
}

@end
