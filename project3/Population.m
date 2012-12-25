//
//  Population.m
//  p3
//
//  Created by VITALIY NESTERENKO on 23.12.12.
//  Copyright (c) 2012 VITALIY NESTERENKO. All rights reserved.
//

#import "Population.h"
#import "Cell.h"



@implementation Population

-(id) init:(int)dna_size {
    self = [super init];
    _dnaLength = dna_size;
    return self;
}


- (void) create:(int)size {
    
    
    _items =  [[NSMutableArray alloc] initWithCapacity:size];
    Cell *cell;
    
    for (int i = 0; i<size; i++) {
        cell = [[Cell alloc] init:_dnaLength];
        cell.targetDNA = _targetDNA;
        [_items insertObject:cell atIndex:i];
    }
    
}

- (Cell *) Item:(int)at {
    return [_items objectAtIndex:at];
}

-(void) Sort {
    
    NSArray *items = [_items sortedArrayUsingSelector:@selector(compare:)];
    _items = [items mutableCopy];
    
}

-(void) replaceWithTop50 {
    
    [self Sort];
    NSRange theRange;
    
    
    theRange.location = 0;
    theRange.length = [_items count] / 2;
    
    BOOL odd_num_elements = ([_items count] % 2 != 0);
    
    NSArray *second = [_items subarrayWithRange:theRange];
    
    
    if (odd_num_elements) {
        theRange.length++;
    }
    
    NSArray *first = [_items subarrayWithRange:theRange];
    
    _items =[ [first arrayByAddingObjectsFromArray:second] mutableCopy];
}

-(void) substituteFromTop50 {
    
  NSUInteger index1 = arc4random() % ([_items count] /2);
  NSUInteger index2 = arc4random() % ([_items count] /2);
    
  Cell *c1 =[_items objectAtIndex:index1];
  Cell *c2 =[_items objectAtIndex:index2];

  Cell *result;
    
    switch (arc4random() % 3) {
        case 0:
            result = [c1 combineWithOther:c2 percent:50 percent_other:50];
            break;
        case 1:
            result = [c1 combineWithOtherByOne:c2];
            break;
        case 2:
            result = [c1 combine20_60_20:c2];
            break;
      }
    

    
    for (int i=[_items count]/2; i< [_items count] ;i++) {
        [_items replaceObjectAtIndex:i withObject:result];
    }
    
    
}

-(NSUInteger )nearestDistanceToTarget {

    Cell *res = [_items objectAtIndex:0];
    return [res distanceToTarget];
}



-(void) print {
    
    for (Cell *cell in _items) {
        NSLog(@"%@ %li",[cell asString],[cell distanceToTarget]);
    }

}


-(void) mutate:(int)percent {
    
    for (Cell *cell in _items) {
        [cell mutate:percent];
    }
    
}

-(BOOL) gotTarget {
    
    
    
    for (Cell *cell in _items) {
        if ([cell distanceToTarget] == 0) {
            return true;
        }
    }
    return false;
}




-(void)generateTarget {
    
    _targetDNA = [[Cell alloc] init:_dnaLength];

}


@end
