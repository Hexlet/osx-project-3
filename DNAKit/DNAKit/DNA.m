//
//  DNAKit.m
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNA.h"

#import "DNAChain+Mutable.h"
#import "DNAOneMiddlePointChainCrossover.h"

@implementation DNA
{
    DNAChain *chain;
}

- (id)initWithLength:(NSUInteger)length
{
    if (self = [super init]) {
        chain = [[DNAChain alloc] initWithRandomElementsLength:length];
    }
    return self;
}

- (id)initWithChain:(DNAChain *)chain
{
    if (self = [super init]) {
        self->chain = chain;
    }
    return self;
}

- (NSUInteger)length
{
    return [chain length];
}

- (NSUInteger)distanceToDNA:(DNA *)dna
{
    return [chain hammingDitanceToDNAChain:dna->chain];
}

- (void)mutate:(float)percent
{
    [chain mutate:percent];
}

- (NSString *)description
{
    return [chain description];
}

+ (DNA *)crossoverDNA:(DNA *)dnaA withDNA:(DNA *)dnaB
{
    static DNABaseChainCrossover *crossover;
    if (!crossover) {
        crossover = [[DNAOneMiddlePointChainCrossover alloc] init];
    }
    return [[DNA alloc] initWithChain:[crossover crossoverDNAChain:dnaA->chain withDNAChain:dnaB->chain]];
}

@end
