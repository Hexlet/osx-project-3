//
//  Cell+OtherMutations.m
//  iDNA
//
//  Created by Stas on 12/30/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import "Cell+OtherMutations.h"

@implementation Cell (OtherMutations)

- (void) mutatex: (int)x {
    NSArray *nucleotides=[NSArray arrayWithObjects: @"A", @"T", @"G", @"C", nil]; //array of nucleotides
    int DNALen = (int)[dna count];
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
            while([[dna objectAtIndex:rand_ind] isEqualTo: [nucleotides objectAtIndex:rand_nuc]]); //check if nucleotide has changed. If it hasn't, repeat replacing
            [dna replaceObjectAtIndex:rand_ind withObject:[nucleotides objectAtIndex:rand_nuc]];//mutate!
            [mutated addObject:[NSNumber numberWithInt:rand_ind]];
            break;
        }
    }
}

@end
