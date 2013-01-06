//
//  Cell.m
//  DNA
//
//  Created by D_Unknown on 11/6/12.
//  Copyright (c) 2012 D_Unknown. All rights reserved.
//

#import "Cell.h"

@implementation Cell

const NSString * nucleotides[4] = {@"A", @"T", @"G", @"C"}; //array of nucleotides

//initialization
-(id) init {
    self=[super init];
    if (self) {
        DNA=[[NSMutableArray alloc] init];
    }
    return self;
}

//initialization whith DNA of given length
-(id) initWithLength:(int)DNALength {
    self = [super init];
    if (self) {
    DNA = [[NSMutableArray alloc] initWithCapacity:DNALength];
    for(int i=0; i<DNALength; i++)
        [DNA insertObject:[self getNucleotide] atIndex:i]; //fill DNA array with nucleotides
    }
    return self;
}

//get DNA string to show in textfield
-(NSString*) getDNAString {
    NSMutableString *DNAString=[[NSMutableString alloc] init];
    for (NSString *element in DNA){
        [DNAString appendString:element];
    }
    return DNAString;
}

//get random nucleotide from nucs array
-(const NSString*) getNucleotide {
    return nucleotides[arc4random()%4];                //return random nucleotide
}

//count hamming distance to another cell
-(int) hammingDistance:(Cell*) c {
    int dist=0;
    for (NSUInteger i=0; i<[self->DNA count]; i++)
        if([[self->DNA objectAtIndex:i] isNotEqualTo: [c->DNA objectAtIndex:i]])
           dist++;                                     //++ hamming distance if nucleotides are not equal
    return dist;
}

//crossbreed with anoter cell
-(Cell*) crossbreedWith:(Cell*) partner {
    Cell *child=[[Cell alloc] init];                   //create a child cell
    NSInteger DNALength=[self->DNA count];
    int rand=arc4random()%3;
    switch (rand) {                                    //choose 1 of 3 crossbreeed ways
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

//mutate cell
-(void) mutate:(int) percent {
    int dnaLength = [DNA count];
    if (percent == 0)                                // if percent = 0, do nothing
        return;                                      
    if (dnaLength != 100)                            // if DNA length isn't 100, recount
        percent = percent * dnaLength / 100;         
    
    // create an array of BOOL, where there are as many YES elems, as number of nucs we need to mutate
    BOOL mas [dnaLength];
    int count = dnaLength;                          
    while (count--)                                 
        mas [count] = count < percent? YES : NO;    
    
    // shuffle BOOL array
    count = dnaLength;                               
    int tempIndex;                                   // buffer to save index of changed elem
    BOOL tempValue;                                  // buffer to save value of changed elem
    while (count--) {                                
        tempIndex = arc4random() % dnaLength;        // get random index 
        tempValue = mas [tempIndex];                 // get value of BOOL at random index
        mas [tempIndex] = mas [count];               // exchange elem at index "count"
        mas [count] = tempValue;                     // whith elem at random index
    }
    
    // mutation itself
    count = dnaLength;                               
    while (count--)                                  
        if (mas[count])                              // if mas[count] = YES, mutate nuc
            [DNA replaceObjectAtIndex:count withObject:[self getNewNucleotide:[DNA objectAtIndex:count]]];
}     

//get new random nuc
-(const NSString*) getNewNucleotide:(NSString *)oldNuc {
    int count;
    for (count = 0; count < 4; count++)
        if (nucleotides[count] == oldNuc)
            break;                                  // get nuc index from 0 to 3 in nucs array, save   it in count
    count = (count + 1 + arc4random() % 3) % 4;     // change index to random index not equal to it
    return nucleotides[count];                      // return elem of nucs array at this index
}

//create DNA from string
-(void) DNAFromString:(NSString*)source withMaxLen:(int) maxLen {
    [self->DNA removeAllObjects];
    NSString *nuc;
    for (int i=0; i<[source length]||i<maxLen; i++) {
        nuc = [NSString stringWithFormat:@"%c", [source characterAtIndex:i]]; //get char from string
        [self->DNA addObject:nuc];                  //add char to DNA string
    }
}

@end
