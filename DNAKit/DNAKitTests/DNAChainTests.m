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
    DNAChain *chain = [[DNAChain alloc] initWithRandomElementsLength:10UL];
    STAssertEquals([[chain description] length], 10UL, nil);
}

- (void)testChainWithElements
{
    DNAElement originElements[] = "AATGCGTACT";
    DNAElement *elements = calloc(strlen(originElements), sizeof(DNAElement));
    memcpy(elements, originElements, strlen(originElements) * sizeof(DNAElement));
    
    DNAChain *chain = [[DNAChain alloc] initWithElements:elements length:2];
    for (NSUInteger i = 0; i < [chain length]; ++i) {
        STAssertEquals([chain elements][i], originElements[i], nil);
    }
}

@end
