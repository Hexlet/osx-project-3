//
//  Cell.m
//  DNA
//
//  Created by D_Unknown on 11/6/12.
//  Copyright (c) 2012 D_Unknown. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id) init {
    self=[super init];
    if (self) {
        DNA=[[NSMutableArray alloc] init];
    }
    return self;
}

-(id) initWithLength:(int)DNALength {
    self = [super init];
    
    if (self) {
    nucleotidesArray = [NSArray arrayWithObjects: @"A", @"T", @"G", @"C", nil]; //array of nucleotides
    DNA = [[NSMutableArray alloc] initWithCapacity:DNALength];
    
    for(int i=0; i<DNALength; i++)
        [DNA insertObject:[self getNucleotide] atIndex:i]; //fill DNA array with nucleotides
    }
    return self;
}

-(NSString*) getDNAString {
    NSMutableString *DNAString=[[NSMutableString alloc] init];
    for (NSString *element in DNA){
        [DNAString appendString:element];
    }
    return DNAString;
}

-(NSString*) getNucleotide {
    return [nucleotidesArray objectAtIndex:(arc4random()%4)]; //get random nucleotide
}

-(int) hammingDistance:(Cell*) c {
    int dist=0;
    for (NSUInteger i=0; i<[self->DNA count]; i++)
        if([[self->DNA objectAtIndex:i] isNotEqualTo: [c->DNA objectAtIndex:i]])
           dist++; //++ hamming distance if nucleotides are not equal
    return dist;
}

-(Cell*) crossbreedWith:(Cell*) partner {
    Cell *child=[[Cell alloc] init];
    NSInteger DNALength=[self->DNA count];
    int rand=arc4random()%3;
    switch (rand) {
        case 0: {
            for (int i=0; i<DNALength/2; i++) {
                [child->DNA addObject:[self->DNA objectAtIndex:i]];
            }
            for (int i=DNALength/2; i<DNALength; i++) {
                [child->DNA addObject:[partner->DNA objectAtIndex:i]];
            }
            break;
        }
            
        case 1: {
            BOOL first=YES;
            for (int i=0; i<DNALength; i++) {
                if (first) {
                    [child->DNA addObject:[self->DNA objectAtIndex:i]];
                    first=NO;
                }
                else {
                    [child->DNA addObject:[partner->DNA objectAtIndex:i]];
                    first=YES;
                }
            }
            break;
        }
        case 2: {
            for (int i=0; i<DNALength*0.2; i++) {
                [child->DNA addObject:[self->DNA objectAtIndex:i]];
            }
            for (int i=DNALength*0.2; i<DNALength*0.8; i++) {
                [child->DNA addObject:[partner->DNA objectAtIndex:i]];
            }
            for (int i=DNALength*0.8; i<DNALength; i++) {
                [child->DNA addObject:[self->DNA objectAtIndex:i]];
            }
            break;
        }

    }
    
    return child;
}

@end
