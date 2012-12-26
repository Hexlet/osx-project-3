//
//  Cell.m
//  Dna
//
//  Created by conference on 22.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id) init {
    self = [super init];
    if (self) {
        dnaBitsArray = [[NSArray alloc] initWithObjects: @"A", @"T", @"G", @"C", nil];
        dnaArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)initialize:(NSInteger)newSize {
    size = newSize;
    for (int i = 0; i < size; i++) {
        int randInt = (int)(random() % 4);
        [dnaArray addObject:[dnaBitsArray objectAtIndex:randInt]];
    }
}

-(void) updateGoalDNA:(NSInteger) newSize {
    dnaArray = [[NSMutableArray alloc] init];
    [self initialize:newSize];
}

-(int) hammingDistance:(Cell*)obj {
    int countMismatch = 0;
    for (int i = 0; i < size; i++) {
        if ([self getObj:i] != [obj getObj:i])
            countMismatch++;
    }
    return countMismatch;
}

-(NSString*) getObj:(int)index {
    return [dnaArray objectAtIndex:index];
}

-(void)mutate:(NSInteger)percents {
    if (percents <= 100) {
        int countReplaces = 0;
        for (int i = 0; i < [dnaArray count]; i++) {
            maskArray[i] = NO;
        }
        while (countReplaces < percents) {
            int percRandInt = (int)(random() % 100);
            int randInt = (int)(random() % 4);
            NSString *string = [[NSString alloc] initWithFormat: [dnaBitsArray objectAtIndex:randInt]];
            NSString *string2 = [[NSString alloc] initWithFormat: [dnaArray objectAtIndex:percRandInt]];
            
            if ((maskArray[percRandInt] == NO) && (string != string2)) {
                maskArray [percRandInt] = YES;
                [dnaArray replaceObjectAtIndex:percRandInt withObject:string];
                countReplaces++;
            }
        }
    }
}

-(NSString*)getGoalDNA {
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < size; i++) {
        [result appendString: [dnaArray objectAtIndex: i]];
    }
    return result;
}

@end
