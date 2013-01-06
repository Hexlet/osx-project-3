//
//  IDNCell.m
//  IDNA
//
//  Created by Dmitriy Zhukov on 07.01.13.
//  Copyright (c) 2013 Dmitriy Zhukov. All rights reserved.
//

#import "IDNCell.h"

@implementation IDNCell

- (id)init {
    self= [super init];
    if (self) {
        _rangeOfDNACellValues = @"ATGC";
        _unitDistanceToTargetDNA = 0;
        _arrayCapacity=0;
        _DNA = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void) fillDNAArrayWithCapacity: (NSInteger)fCapacity {
  _arrayCapacity = fCapacity;
    NSMutableArray* setDNA = [NSMutableArray arrayWithCapacity:_arrayCapacity];
    
    for (NSInteger i = 0 ; i < _arrayCapacity; i++) {
        [setDNA addObject:[NSString stringWithFormat:@"%C", [_rangeOfDNACellValues characterAtIndex: arc4random() % [_rangeOfDNACellValues length]]]];
    }
    _DNA = setDNA;
}

- (NSInteger) hammingDistance: (IDNCell*) anotherDNA {
    NSInteger count = 0;
    for (NSInteger i = 0 ; i < _arrayCapacity; i++) { 
        if ([[_DNA objectAtIndex:i] isNotEqualTo:[anotherDNA.DNA objectAtIndex: i]]) {
            count++;
        }
    }
    return count;
}

- (void)mutate: (NSInteger) procentageOfMutations {
    
    NSInteger numberOfcells = (_arrayCapacity*procentageOfMutations)/100;
    NSMutableIndexSet *indexSetDNA = [[NSMutableIndexSet alloc] init];    
    
    for (NSInteger i = 0; i < numberOfcells; i++) {
        NSInteger indexGen = arc4random ()%_arrayCapacity;
        
        if (![indexSetDNA containsIndex:indexGen]) {
            [indexSetDNA addIndex:indexGen];             
           
            for(;;) {
                NSString *changes =[NSString stringWithFormat:@"%C", [_rangeOfDNACellValues characterAtIndex: arc4random() % [_rangeOfDNACellValues length]]];
                
                if (![[_DNA objectAtIndex: indexGen] isEqualToString:changes]) {
                    [_DNA replaceObjectAtIndex:indexGen withObject:changes];
                    break; 
                }
            }
            
        } else {i--;}
    }
}


@end
