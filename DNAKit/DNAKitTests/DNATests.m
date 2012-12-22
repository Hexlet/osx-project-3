//
//  DNAKitTests.m
//  DNAKitTests
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNATests.h"

#import "DNA.h"

@implementation DNATests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)createSimpleDNA
{
    DNA *dna = [DNA dnaWithLength:10];
    STAssertEquals([[dna description] length], 10UL, @"What the f**k?!");
}

@end
