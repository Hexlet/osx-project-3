//
//  OneMiddlePointDNAChainCrossoverTests.m
//  DNAKit
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNAOneMiddlePointChainCrossoverTests.h"

#import "DNAChain.h"
#import "DNAOneMiddlePointChainCrossover.h"


@implementation DNAOneMiddlePointChainCrossoverTests

- (void)testCrossoverDNAChainWithEqualLengths
{
    DNAChain *chainA = [[DNAChain alloc] initWithRandomElementsLength:3];
    DNAChain *chainB = [[DNAChain alloc] initWithRandomElementsLength:3];
    DNAOneMiddlePointChainCrossover *crossover = [[DNAOneMiddlePointChainCrossover alloc] init];
    
    DNAChain *crossoverChain = nil;
    
    STAssertNoThrowSpecificNamed(crossoverChain = [crossover crossoverDNAChain:chainA withDNAChain:chainB], NSException, @"NonEqualLengthException", nil);
    STAssertNotNil(crossoverChain, nil);
    STAssertEquals([crossoverChain length], [chainA length], nil);
}

- (void)testCrossoverDNAChainWithNonEqualLengths
{
    DNAChain *chainA = [[DNAChain alloc] initWithRandomElementsLength:2];
    DNAChain *chainB = [[DNAChain alloc] initWithRandomElementsLength:3];
    DNAOneMiddlePointChainCrossover *crossover = [[DNAOneMiddlePointChainCrossover alloc] init];
    
    DNAChain *crossoverChain = nil;
    
    STAssertThrowsSpecificNamed(crossoverChain = [crossover crossoverDNAChain:chainA withDNAChain:chainB], NSException, @"NonEqualLengthException", nil);
}

- (void)testOneMiddlePointCrossoverForEvenLength
{
    DNAChain *chainA = [[DNAChain alloc] initWithRandomElementsLength:4];
    DNAChain *chainB = [[DNAChain alloc] initWithRandomElementsLength:4];
    DNAOneMiddlePointChainCrossover *crossover = [[DNAOneMiddlePointChainCrossover alloc] init];
    
    DNAChain *resultChain = [crossover crossoverDNAChain:chainA withDNAChain:chainB];
    
    NSUInteger middle = [resultChain length] / 2;
    for (NSUInteger i = 0; i < [resultChain length]; ++i) {
        if (i < middle) {
            STAssertEquals([resultChain elements][i], [chainA elements][i], nil);
        } else {
            STAssertEquals([resultChain elements][i], [chainB elements][i], nil);
        }
    }
}

- (void)testOneMiddlePointCrossoverForOddLength
{
    DNAChain *chainA = [[DNAChain alloc] initWithRandomElementsLength:5];
    DNAChain *chainB = [[DNAChain alloc] initWithRandomElementsLength:5];
    DNAOneMiddlePointChainCrossover *crossover = [[DNAOneMiddlePointChainCrossover alloc] init];
    
    DNAChain *resultChain = [crossover crossoverDNAChain:chainA withDNAChain:chainB];
    
    NSUInteger middle = [resultChain length] / 2;
    for (NSUInteger i = 0; i < [resultChain length]; ++i) {
        if (i < middle) {
            STAssertEquals([resultChain elements][i], [chainA elements][i], nil);
        }
        else if (i == middle) {
            STAssertTrue([resultChain elements][i] == [chainA elements][i] || [resultChain elements][i] == [chainB elements][i], nil);
        }
        else {
            STAssertEquals([resultChain elements][i], [chainB elements][i], nil);
        }
    }
}

@end
