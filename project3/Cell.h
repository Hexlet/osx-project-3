//
//  Cell.h
//  p3
//
//  Created by VITALIY NESTERENKO on 23.12.12.
//  Copyright (c) 2012 VITALIY NESTERENKO. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface Cell : NSObject

    - (unsigned long) getRandomNumber:(unsigned long)from to:(unsigned long)to;
    -(void)fillArrayWithRandomSequence:(unsigned long)from to:(unsigned long)to count:(unsigned long)count sequnce:(unsigned long *)sequence ;

    @property NSMutableArray * DNA;
    @property Cell *targetDNA;

    @property unsigned long nuclCount;

    - (id) init:(unsigned long)count;
    -(id) initWithAllA:(unsigned long)count;
    -(id) initWithAllB:(unsigned long)count;

    -(NSUInteger) distanceToTarget;
    -(Cell *) partOfCell:(unsigned long)percent;
    - (NSString *) randomNucleotide;
    - (int) hammingDistance:(Cell *)other_cell;
    -(NSString *) asString;
    - (void) mutate:(int)percent;
    -(Cell *) combineWithOther:(Cell*)other_cell percent:(unsigned long)percent percent_other:(unsigned long)percent_other;
    -(Cell *) combineWithOtherByOne:(Cell*)other_cell;
    -(Cell *) combine20_60_20:(Cell *)other_cell;
@end
