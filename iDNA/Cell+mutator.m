//
//  Cell+mutator.m
//  dna
//
//  Created by Igor Pavlov on 03.11.12.
//  Copyright (c) 2012 Igor Pavlov. All rights reserved.
//

#import "Cell+mutator.h"


@implementation Cell (mutator)


- (void) mutate:(NSInteger)percent
{
    const NSInteger maxPercent = 100;
    
    // проверка на правильность аргумента
    if (percent < 0  ||  percent > maxPercent)
        @throw [NSException exceptionWithName:NSRangeException reason:@"argument is out of [0..100] range" userInfo:nil];
    
    // если задано изменение 0%, то ничего делать не надо, сразу выход
    if (0 == percent)
        return;
    
    const NSUInteger dnaLength = [dna length];
    
    // создать массив индексов и зарезервировать в нем место
    NSMutableArray *mutationFlags = [NSMutableArray arrayWithCapacity:dnaLength];

    // количество символов к мутации
    const NSUInteger mutationIndexCount = dnaLength*percent/maxPercent;

    // заполнить индексы
    for (NSUInteger i = 0; i != dnaLength; ++i)
    {
        if (i < mutationIndexCount)
            [mutationFlags addObject:[NSNumber numberWithBool:YES]];
        else
            [mutationFlags addObject:[NSNumber numberWithBool:NO]];
    }

    // если мутация затрагивает менее 100% символов, перемешать индексы для случайности изменений
    if (mutationIndexCount < dnaLength)
    {
        // перемешивание
        for (NSUInteger i = 0; i != mutationIndexCount; ++i)
        {
            const NSUInteger j = i + arc4random_uniform((u_int32_t)(dnaLength - i));
            [mutationFlags exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }

    const NSString  *nucleotides     = [Cell getNucleotides];
    const NSUInteger nucleotideCount = [nucleotides length];

    NSMutableString *newDna = [NSMutableString stringWithCapacity:dnaLength];

    for (NSUInteger i = 0; i != dnaLength; ++i)
    {
        NSString *c = [dna substringWithRange:NSMakeRange(i, 1)];
        if ([[mutationFlags objectAtIndex:i] boolValue])
        {
            const NSUInteger curNucleotideIndex = [nucleotides rangeOfString:c].location;
            const NSUInteger newNucleotideIndex = (curNucleotideIndex + 1 + arc4random_uniform((u_int32_t)(nucleotideCount - 1))) % nucleotideCount;
            c = [nucleotides substringWithRange:NSMakeRange(newNucleotideIndex, 1)];
        }
        [newDna appendString:c];
    }
    
    dna = newDna;
}

@end
