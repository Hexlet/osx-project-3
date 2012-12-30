//
//  Cell+Mutate.m
//  DNA
//
//  Created by D_Unknown on 11/6/12.
//  Copyright (c) 2012 D_Unknown. All rights reserved.
//

#import "Cell+Mutate.h"

@implementation Cell (Mutate)

-(void) mutate:(int)x {
    NSArray  *nucleotides=[NSArray arrayWithObjects: @"A", @"T", @"G", @"C", nil]; //array of nucleotides
    int DNALen = [DNA count];
    int NucsToMut=x*DNALen/100;
    int rand_ind, rand_nuc;
    NSMutableArray *mutated = [[NSMutableArray alloc] init];
    
    for (int i=0; i<NucsToMut; i++) {
        while (true) {
            rand_ind = arc4random()%DNALen; //get random index in DNA for replacement
            if([mutated containsObject:[NSNumber numberWithInt:rand_ind]])
                continue; //check if it has been already replaced, if so get another index
            do {
                rand_nuc = arc4random()%4;//get random nuc
            }
            while([[DNA objectAtIndex:rand_ind] isEqualTo: [nucleotides objectAtIndex:rand_nuc]]); //check if nucleotide has changed. If it hasn't, repeat replacing
            [DNA replaceObjectAtIndex:rand_ind withObject:[nucleotides objectAtIndex:rand_nuc]];//mutate!
            [mutated addObject:[NSNumber numberWithInt:rand_ind]];
            break;
        }
    }
}     

@end
