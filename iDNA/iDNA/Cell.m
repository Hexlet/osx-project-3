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
        [self initNucleotides];
        [self initDNAWithlength:100];   
    }
    
    return self;
}

-(id) initWithDNAlength: (NSInteger) length
{
	if (self = [super init])
	{
		[self initNucleotides];
		[self initDNAWithlength:length];
	}
	return self;
}

-(void) initDNAWithlength: (NSInteger) length
{
	int DNAsize = (int) length;
	
	// First init of DNA array.
	DNA = [[NSMutableArray alloc] initWithCapacity:DNAsize];
	
	// Fill with random nucleotides from corresponding array.
	for (NSInteger i=0; i < DNAsize; i++)
	{
		[DNA setObject:[self randomNucleotide] atIndexedSubscript:i];
	}
}

-(void) initNucleotides
{
	// Possible elements.
	nucleotide = [[NSArray alloc] initWithObjects:@"A", @"C", @"G", @"T", nil];
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

-(Cell *) crossWithCell: (Cell *) otherCell
{
	switch (arc4random_uniform(3))
	{
		case 0:
			return [self crossByHalfWithCell:otherCell];
		case 1:
			return [self crossByOnePercentWithCell:otherCell];
		case 2:
			return [self crossByPartsWithCell:otherCell];
		default: return self;
	}
}

-(Cell *) crossByHalfWithCell: (Cell *) otherCell
{
	if ([self DNAsize] != [otherCell DNAsize])
		return self;
	Cell *newCell = [self copy];
	
	for (NSInteger i = [self DNAsize] / 2; i<[self DNAsize]; i++)
		[newCell setDNA:[otherCell getDNAatIndex:i] atIndex:i];
	
	return newCell;
}

-(Cell *) crossByOnePercentWithCell: (Cell *) otherCell
{
	if ([self DNAsize] != [otherCell DNAsize])
		return self;
	Cell *newCell = [self copy];
	
	// Simpler method described in module video.
	for (NSInteger i = 0; i < [self DNAsize]; i++)
	{
		if (i % 2 == 1)
			[newCell setDNA:[otherCell getDNAatIndex:i] atIndex:i];
	}
	return newCell;
}

-(Cell *) crossByPartsWithCell: (Cell *) otherCell
{
	if ([self DNAsize] != [otherCell DNAsize])
		return self;
	Cell *newCell = [self copy];
	
	for (NSInteger i = [self DNAsize]/5; i < 4*[self DNAsize]/5; i++)
		[newCell setDNA:[otherCell getDNAatIndex:i] atIndex:i];
	return newCell;
}

-(NSString *) DNAtoString
{
	NSMutableString *output = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < [self DNAsize]; i++)
    {
        [output appendString: [self getDNAatIndex:i]];
    }
	return output;
}

@end
