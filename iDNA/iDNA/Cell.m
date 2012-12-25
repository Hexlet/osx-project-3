//
//  Cell.m
//  iDNA
//
//  Created by n on 25.12.12.
//  Copyright (c) 2012 witzawitz. All rights reserved.
//

#import "Cell.h"
#import "NSMutableArray+Shuffle.h"

@implementation Cell
{
    NSMutableArray *DNA;
    NSArray *nucleotide;
}

-(id) init
{
    self = [super init];
    
    if (self)
    {
        // Size of DNA array.
        int DNAsize = 100;
        
        // Possible elements.
        nucleotide = [[NSArray alloc] initWithObjects:@"A", @"C", @"G", @"T", nil];
        
        // First init of DNA array.
        DNA = [[NSMutableArray alloc] initWithCapacity:DNAsize];
        
        // Fill with random nucleotides from corresponding array.
        for (NSInteger i=0; i < DNAsize; i++)
        {
            [DNA setObject:[self randomNucleotide] atIndexedSubscript:i];
        }
    }
    
    return self;
}

-(int) hammingDistance: (Cell *) cell
{
    int dist = 0;
    
    // In case DNA size of two cells are differents.
    NSInteger minDNAsize = MIN([cell DNAsize], [self DNAsize]);
    NSInteger maxDNAsize = MAX([cell DNAsize], [self DNAsize]);
	
    // Comparing elements.
    for (NSInteger i=0; i<minDNAsize; i++)
    {
        if (![[cell getDNAatIndex:i] isEqualToString:[self getDNAatIndex:i]])
        {
            dist++;
        }
    }
    
    // The tail of one of DNA. Will add 0 in case sizes of DNA are equal.
    dist += (maxDNAsize - minDNAsize);
    
    return dist;
}

// Returns the size of DNA array.
-(NSInteger) DNAsize
{
    return [DNA count];
}

// Gets nucleotide at given index.
-(NSString *) getDNAatIndex: (NSInteger)index
{
    if ((index < 0) || (index >= [self DNAsize]))
        return nil;
    return [DNA objectAtIndex:index];
}

// Sets DNA nucleotide at given index.
-(void) setDNA: (NSString *) nucluotide atIndex: (NSInteger)index
{
    if ((index >= 0) && (index < [self DNAsize]))
    {
        [DNA setObject:nucluotide atIndexedSubscript:index];
    }
}

// Return random nucleotide from corresponding array.
-(NSString *) randomNucleotide
{
    if ([nucleotide count] > 0)
        return [nucleotide objectAtIndex:arc4random_uniform((int)[nucleotide count])];
    else
        return @"";
}

-(void) mutate: (int) percentToReplace
{
    // Explicit number of element to replace.
    NSInteger replace = percentToReplace * [self DNAsize] / 100;
    
    // Some preparation in case of data out of range.
    if (replace < 0)
        replace = 0;
    if (replace > [self DNAsize])
        replace = [self DNAsize];
    
    // Nothing to do here.
    if (replace == 0)
        return;
    
    NSInteger i = 0;
    
    // Array that stores indices to replace.
    NSMutableArray *indicesToReplace = [[NSMutableArray alloc] initWithCapacity:[self DNAsize]];
    for (i = 0; i < [self DNAsize]; i++)
        [indicesToReplace setObject:[NSNumber numberWithInteger:i] atIndexedSubscript:i];
    // Shuffle it!
    [indicesToReplace shuffle];
    
    // To store generated nucleotide.
    NSString *tempNucleotide = [[NSString alloc] init];
    NSInteger DNAindex = 0;
    
    for (i = 0; i < replace; i++)
    {
        // Index of DNA array.
        DNAindex = [[indicesToReplace objectAtIndex:i] integerValue];
        // Generate string different from that in DNA array.
        do
        {
            tempNucleotide = [self randomNucleotide];
        }
        while ([[self getDNAatIndex:DNAindex] isEqualToString:tempNucleotide]);
        
        [self setDNA:tempNucleotide atIndex:DNAindex];
    }
}

@end
