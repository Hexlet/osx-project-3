//
//  Cell.m
//  p3
//
//  Created by VITALIY NESTERENKO on 23.12.12.
//  Copyright (c) 2012 VITALIY NESTERENKO. All rights reserved.
//

#import "Cell.h"




@implementation Cell


- (unsigned long) getRandomNumber:(unsigned long)from to:(unsigned long)to {
    return (unsigned long)from + arc4random() % (to-from+1);
}


// Возвращает последовательность случайных числел в диапазоне [from - to] в количестве count
//
-(void)fillArrayWithRandomSequence:(unsigned long)from to:(unsigned long)to count:(unsigned long)count sequnce:(unsigned long *)sequence {
    unsigned long new_random_value;
    
    Boolean found;
    
    for (int i = 0; i < count; i++) {
        
        found = YES;
        
        while (found) {
            
            new_random_value = [self getRandomNumber:from to:to];
            found = NO;
            
            for (int j=0; j < count; j++) {
                if (new_random_value == sequence[j])
                    found = YES;
            }
            
        }
        
        sequence[i] = new_random_value;
        
    }
    
}

- (NSString *) randomNucleotide {
    NSString *nucleotids[4] = {@"A",@"T",@"G",@"C"};
    return nucleotids[[self getRandomNumber:0 to:3]];
}


- (id) init:(unsigned long)count {
    self = [super init];
    _nuclCount = count;
    _DNA = [[NSMutableArray alloc] initWithCapacity:_nuclCount];
    
    
    for (int i = 0 ; i < count; i++) {
        [_DNA insertObject:[self randomNucleotide] atIndex:i];
    }

    return self;
}


-(id) initWithAllA:(unsigned long)count {
    
    self = [self init:count];
    for (int i=0; i< _nuclCount; i++) {
        [_DNA replaceObjectAtIndex:i withObject:@"A"];
    }
    
    return self;
    
}

-(id) initWithAllB:(unsigned long)count {
    
    self = [self init:count];
    for (int i=0; i< _nuclCount; i++) {
        [_DNA replaceObjectAtIndex:i withObject:@"B"];
    }
    
    return self;
    
}

- (int) hammingDistance:(Cell *)other_cell {
    
    int result = 0;
    
    for (int i = 0; i < _nuclCount; i++) {
        
        if (  ![[_DNA objectAtIndex:i] isEqualToString:[other_cell.DNA objectAtIndex:i] ] ) {
            result ++;
        }
    }
    
    return result;
}

- (NSComparisonResult) compare:(Cell*) anotherCell {
    
    if ([self distanceToTarget] > [anotherCell distanceToTarget]) {
        return 1;
    } else {
        return -1;
    }
    
}

- (void) copyFromOther:(Cell *)other_cell {
    for (int i=0; i<_nuclCount;i++) {
        [_DNA replaceObjectAtIndex:i withObject: [other_cell.DNA objectAtIndex:i] ];
        
    }
    
}

-(NSString *) asString {
    
    return [_DNA componentsJoinedByString:@""];
    
}

-(NSUInteger) distanceToTarget {
    return [self hammingDistance:_targetDNA];
}

-(Cell *) partOfCell:(unsigned long)percent {
    
    NSRange theRange;
    theRange.location = 0;
    theRange.length = [_DNA count]*percent/100;
    NSMutableArray *dna = [[_DNA subarrayWithRange:theRange] mutableCopy];
    Cell *cell = [[Cell alloc] init:theRange.length];
    cell.DNA = dna;
    
    return cell;
    
}


- (void) mutate:(int)percent {
    
    unsigned long positions_to_change_count = (unsigned long)((_nuclCount * percent) / 100);
    unsigned long positions[positions_to_change_count];
    
    NSString *current_nucleotide;
    NSString *mutated_nucleotide;
    
    
    
    [self fillArrayWithRandomSequence:0 to:(_nuclCount-1) count:positions_to_change_count sequnce:positions];
    
    for (int i = 0; i < positions_to_change_count; i++) {
        
        current_nucleotide = [_DNA objectAtIndex:positions[i]];
        
        while ([current_nucleotide isEqualToString: (mutated_nucleotide = [self randomNucleotide]) ] ) {
            mutated_nucleotide = [self randomNucleotide];
        }
        
        [_DNA replaceObjectAtIndex:positions[i] withObject: mutated_nucleotide];
        
    }
    
    
}

-(Cell *) combine20_60_20:(Cell *)other_cell {
    unsigned long initial_length = _DNA.count;
    
    Cell *p1 =[self partOfCell:20];
    Cell *p2 =[other_cell partOfCell:60];
    Cell *p3 =[self partOfCell:20];
    
    Cell *result=[[Cell alloc] init:_DNA.count];
    result.targetDNA = self.targetDNA;
    
    
    result.DNA = [[p1.DNA arrayByAddingObjectsFromArray:p2.DNA] mutableCopy];
    result.DNA =[[result.DNA arrayByAddingObjectsFromArray:p3.DNA] mutableCopy];
    
    
    unsigned long parts_length = p1.DNA.count+p2.DNA.count+p3.DNA.count;
    
    if (parts_length  < initial_length ) {
       
        NSUInteger diff = initial_length - parts_length;
        
        result.DNA = [[result.DNA arrayByAddingObjectsFromArray:[other_cell.DNA subarrayWithRange:NSMakeRange(p1.DNA.count, diff)]] mutableCopy];
        
    }
    
    return result;
    
}

-(Cell *) combineWithOther:(Cell*)other_cell percent:(unsigned long)percent percent_other:(unsigned long)percent_other {
    
        unsigned long initial_length = _DNA.count;
    
        Cell *p1 =[self partOfCell:percent];
        Cell *p2 =[other_cell partOfCell:percent_other];
    
//        NSLog(@"Part1: %@ %i",[p1 asString],[p1 distanceToTarget]);
//    
//        NSLog(@"Part2: %@ %i",[p2 asString],[p2 distanceToTarget]);
    
        Cell *result=[[Cell alloc] init:_DNA.count];
        result.targetDNA = self.targetDNA;
    
        result.DNA = [[p1.DNA arrayByAddingObjectsFromArray:p2.DNA] mutableCopy];
        
        unsigned long parts_length = p1.DNA.count+p2.DNA.count;
        
        if (parts_length  < initial_length ) {
            NSString *last_element = [other_cell.DNA objectAtIndex:p2.DNA.count];
            [result.DNA insertObject:last_element atIndex:(initial_length-1)];
        }
   
    return result;
}

-(Cell *) combineWithOtherByOne:(Cell*)other_cell {

    NSString *p1,*p2;
    unsigned long target_length = _DNA.count;
    Cell *result=[[Cell alloc] init:_DNA.count];
    result.targetDNA = self.targetDNA;

    unsigned long result_count = 0;
    
    for (int i = 0; i<target_length; i += 2) {
        
       p1 = [self.DNA objectAtIndex:i];
       p2 = [other_cell.DNA objectAtIndex:i];
        
        if (result_count == target_length) {
            break;
        } else {
            [result.DNA replaceObjectAtIndex:i withObject:p1];
        }
        
        result_count++;
        
        if (result_count == target_length) {
            break;
        } else {
            [result.DNA replaceObjectAtIndex:i+1 withObject:p2];
        }
        
        
        
        result_count++;
        
    }
    return result;
}
@end


