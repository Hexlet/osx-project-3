//
//  DNAChain+Mutable.m
//  DNAKit
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNAChain+Mutable.h"


@implementation DNAChain (Mutable)

- (void)mutate:(float)percent
{
    if (percent > 1) {
        @throw [NSException exceptionWithName:@"IllegalMutationPercentException" reason:@"Mutate percent greater than 100!" userInfo:nil];
    }
    
    NSUInteger portion = round([self length] * percent);
    
    static NSMutableArray *indexes;
    if (indexes == nil || [indexes count] != [self length]) {
        indexes = [NSMutableArray array];
        for (NSUInteger i = 0; i < [self length]; ++i)
            [indexes addObject:[NSNumber numberWithUnsignedInteger:i]];
    }

    for (NSUInteger i = 0; i < portion; ++i) {
        [indexes exchangeObjectAtIndex:i withObjectAtIndex:i + arc4random() % ([self length] - i)];
    }
    
    for (NSUInteger i = 0; i < portion; ++i){
        NSUInteger index = [[indexes objectAtIndex:i] integerValue];
        [self elements][index] = [DNAChain getRandomElementExceptElement:[self elements][index]];
    }
}

+ (DNAElement)getRandomElementExceptElement:(DNAElement)element
{
    NSUInteger index = DNA_CHAIN_ELEMENT_COUNT;
    for (NSUInteger i = 0; i < DNA_CHAIN_ELEMENT_COUNT; ++i) {
        if (DNA_CHAIN_ELEMENTS[i] == element) {
            index = i;
        }
    }
    return DNA_CHAIN_ELEMENTS[(index + 1 + arc4random() % (DNA_CHAIN_ELEMENT_COUNT - 1)) % DNA_CHAIN_ELEMENT_COUNT];
}

@end
