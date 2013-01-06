//
//  Cell.m
//  iDNA
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id)initWithLength:(int) l {
    
    if (self = [super init]) {
        _maxSetSymbols = l;
        _nucleotides = [[NSArray alloc] initWithObjects: @"A", @"T", @"G", @"C", nil];
        _nucleotidesCount = (int)[_nucleotides count];
        _DNA = [[NSMutableArray alloc] initWithCapacity:_maxSetSymbols];
        
        for (int i = 0; i < _maxSetSymbols; ++i) {
            int symbolOfSet = arc4random_uniform(_nucleotidesCount);
            [_DNA addObject: [_nucleotides objectAtIndex: symbolOfSet]];
        }
    }
    return self;
}

- (id)init
{
    return [self initWithLength:100];
}

-(int) hammingDistance: (Cell*) theCell {
    
    int count = 0;
    
    for (int i = 0; i < _maxSetSymbols; ++i) {
        if (![[_DNA objectAtIndex:i] isEqual:[[theCell DNA] objectAtIndex:i]])
            ++count;
    }
    
    return count;
}

-(void) mutate: (int) x {
    
    @try {
        [self mutateWithExctption: x];
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@",exception);
    }
}

-(void) mutateWithExctption: (int) x {
    
    if (x < 0 || x > 100) @throw [NSException exceptionWithName:@"InvalidNumbersOfPercent" reason: @"Can't mutate less or more 100 percent of genes" userInfo:nil];
    
    int symbolsCount = x * [self maxSetSymbols] / 100;
    
    NSMutableArray *changesList = [[NSMutableArray alloc] init];
    BOOL flag = NO;
    
    while (symbolsCount) {
        
        NSNumber* numberChanging = [NSNumber numberWithInt: arc4random_uniform([self maxSetSymbols])];
        
        for (NSNumber* n in changesList) {
            if (n == numberChanging) {
                flag = YES;
                break;
            }
        }
        
        if (!flag) {
            int symbolOfSet = arc4random_uniform([self nucleotidesCount]);
            
            if (![[[self DNA] objectAtIndex: [numberChanging intValue]] isEqual:
                  [[self nucleotides] objectAtIndex:symbolOfSet]]) {
                
                [changesList addObject: numberChanging];
                [[self DNA] replaceObjectAtIndex: [numberChanging intValue]
                                      withObject:[[self nucleotides] objectAtIndex:symbolOfSet]];
                
                --symbolsCount;
            }
        }
        
        flag = NO;
    }
}


@end
