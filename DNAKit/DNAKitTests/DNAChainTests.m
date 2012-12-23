//
//  DNAChainTests.m
//  DNAKit
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNAChainTests.h"

#import "DNAChain+Mutable.h"


@implementation DNAChainTests

- (void)testSimpleChain
{
    DNAChain *chain = [[DNAChain alloc] initWithRandomElementsLength:10];
    STAssertEquals([[chain description] length], 10UL, nil);
}

- (void)testChainWithElements
{
    DNAElement originElements[] = "AATGCGTACT";
    DNAChain *chain = [[DNAChain alloc] initWithElements:[self createElementsFromOriginElements:originElements]
                                                  length:strlen(originElements)];
    for (NSUInteger i = 0; i < [chain length]; ++i) {
        STAssertEquals([chain elements][i], originElements[i], nil);
    }
}

- (void)testMutateChainOnMoreThan100Percent
{
    DNAChain *chain = [[DNAChain alloc] initWithRandomElementsLength:10];
    STAssertThrowsSpecificNamed([chain mutate:110], NSException, @"IllegalMutationPercentException", nil);
}

- (void)testMutateChain
{
    DNAElement originElements[] = "AATGCGTACT";
    DNAChain *chain = [[DNAChain alloc] initWithElements:[self createElementsFromOriginElements:originElements]
                                                  length:strlen(originElements)];
    [chain mutate:20];
    BOOL changed = NO;
    for (NSUInteger i = 0; i < [chain length]; ++i) {
        if ([chain elements][i] != originElements[i]) {
            changed = YES;
        }
    }
    STAssertTrue(changed, nil);
}

- (void)testMutateChainOnExactPercent
{
    DNAChain *chain = [[DNAChain alloc] initWithRandomElementsLength:1000];
    DNAElement *originElements = calloc([chain length], sizeof(DNAElement));
    memcpy(originElements, [chain elements], [chain length] * sizeof(DNAElement));
    [chain mutate:20];
    NSUInteger distinctElementsCount = 0;
    for (NSUInteger i = 0; i < [chain length]; ++i) {
        if ([chain elements][i] != originElements[i]) {
            ++distinctElementsCount;
        }
    }
    free(originElements);
    STAssertEquals(distinctElementsCount, 200UL, nil);
}

- (DNAElement *)createElementsFromOriginElements:(DNAElement *)originElements
{
    DNAElement *elements = calloc(strlen(originElements), sizeof(DNAElement));
    memcpy(elements, originElements, strlen(originElements) * sizeof(DNAElement));
    return  elements;
}

@end
