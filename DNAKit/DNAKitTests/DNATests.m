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

- (void)testCreateSimpleDNA
{
    DNA *dna = [[DNA alloc] initWithLength:10UL];
    STAssertEquals([[dna description] length], 10UL, @"Created DNA has wrong chain length!");
}

@end
