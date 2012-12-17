//
//  YKDNA.m
//  iDNA
//
//  Created by Yuri Kirghisov on 17.12.12.
//  Copyright (c) 2012 Yuri Kirghisov. All rights reserved.
//

#import "YKDNA.h"
#include <stdlib.h>

@implementation YKDNA

- (YKDNA *)initWithLength:(NSUInteger)length
{
    if (self = [super init]) {
        dnaLetters = [NSArray arrayWithObjects:@"A", @"C", @"G", @"T", nil];

        NSMutableString *newDNA = [NSMutableString string];
        for (NSUInteger i=0; i<length; i++) {
            [newDNA appendString:[dnaLetters objectAtIndex:arc4random_uniform((unsigned int)[dnaLetters count])]];
        }

        self.dnaString = [NSString stringWithString:newDNA];
    }
    
    return self;
}

- (NSUInteger)hammingDistance
{
    return 0;
}

- (void)mutateWithPercentage:(NSUInteger)percentage
{
    
}

- (NSComparisonResult)compareHammingDistanceToHammingDistanceOfDNA:(YKDNA *)aDNA
{
    if (!aDNA)
        return NSOrderedSame;
    
    NSUInteger hammingDistance1 = [self hammingDistance];
    NSUInteger hammingDistance2 = [aDNA hammingDistance];

    // Comparing hamming distances
    if (hammingDistance1 == hammingDistance2)
        return NSOrderedSame;
    else if (hammingDistance1 < hammingDistance2)
        return NSOrderedAscending;
    else
        return NSOrderedDescending;
}


@end
