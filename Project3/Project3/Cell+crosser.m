//
//  Cell+crosser.m
//  Project3
//
//  Created by Bogdan Pankiv on 12/25/12.
//  Copyright (c) 2012 Bogdan Pankiv. All rights reserved.
//

#import "Cell+crosser.h"

@implementation Cell (crosser)

-(void)cross: (Cell *)cell {
    for (int i=0; i<dnaLength; ++i) {
        if (i%2 == 0) dna[i] = [cell getDnaAtPosition:i];
    }
}

@end
