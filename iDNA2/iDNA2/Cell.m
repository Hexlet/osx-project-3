//
//  Cell.m
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 03.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize dnaLength = _dnaLength;
@synthesize DNA = _DNA;

+ (NSString *)getRandomNucleotide {
    // генерируем случайный индекс от 0 до 3
    NSUInteger randomIndex = arc4random() % 4;
    
    // на основе индекса вытаскиваем соответствующий символ из массива нуклеотидов
    char nucleotideChar = nucleotides[randomIndex];
    
    // на основе символа создаем объект типа NSString
    NSString * nucleotideObj = [NSString stringWithFormat:@"%c",nucleotideChar];
    
    // и возвращаем его
    return nucleotideObj;
}

+ (Cell *)getCellWithDna:(NSString *)dna {
    Cell * newCell = [[Cell alloc] init];
    if (newCell && [Cell dnaIsCorrect:dna]) {
        newCell.dnaLength = [dna length];
        newCell.DNA = [NSMutableArray arrayWithCapacity:newCell.dnaLength];
        for (NSUInteger i = 0; i < [dna length]; i++) {
            NSString * nucleotide = [NSString stringWithFormat:@"%c", [dna characterAtIndex:i]];
            [newCell->_DNA addObject:nucleotide];
        }
    }
    return newCell;
}

+ (Cell *)getCellWithDnaLength:(NSUInteger)dnaLength {
    // убеждаемся что dnaLength больше нуля
    if (dnaLength == 0) {
        [NSException raise:@"zero dna length" format:@"dna length provided is equal to zero"];
    }
    Cell * newCell = [[Cell alloc] init];
    if (newCell) {
        newCell.dnaLength = dnaLength;
        [newCell fillDnaOnce];
    }
    return newCell;
}

+ (Cell *)randomlyCrossingMom:(Cell *)mom andDad:(Cell *)dad {
    Cell * newCell;
    if (mom.dnaLength != dad.dnaLength) {
        [NSException raise:@"incorrect cells passed" 
                    format:@"Cells have differen dna length: %lu & %lu", mom.dnaLength, dad.dnaLength];
    } else if ([mom->_DNA count] != mom.dnaLength) {
        [NSException raise:@"Mom's cell not completed" 
                    format:@"Mom's cell not completed"];
    } else if ([dad->_DNA count] != dad.dnaLength) {
        [NSException raise:@"Dad's cell not completed" 
                    format:@"Dad's cell not completed"];
    } else {
        // используем случайный метод скрещивания
        NSUInteger crossingMethod = arc4random() % 3;
        switch (crossingMethod) {
            case 0:
                newCell = [mom crossingHaflByHalfWithCell:dad];
                break;
            case 1:
                newCell = [mom crossingEvenOddWithCell:dad];
                break;
            default:
                newCell = [mom crossing206020WithCell:dad];
                break;
        }
    }
    return newCell;
}

+ (BOOL)dnaIsCorrect:(NSString *)dnaString {
    if ([dnaString length] > 0) {
        NSString * nucleotidesString = [NSString stringWithCString:nucleotides encoding:NSUTF8StringEncoding];
        NSCharacterSet * nucleotidesSet = [NSCharacterSet characterSetWithCharactersInString:nucleotidesString];
        NSString * trimmedDnaString = [dnaString stringByTrimmingCharactersInSet:nucleotidesSet];
        if ([trimmedDnaString isEqualToString:@""]) {
            return YES;
        }
    }
    return NO;
}

- (void)fillDnaOnce {
    // убеждаемся, что поле DNA не было заполнено
    if ([_DNA count] > 0) {
        [NSException raise:@"DNA is not empty" 
                    format:@"field DNA is not empty, it contains \
         %lu elements", [_DNA count]];
    } else {
        // заполняем цепь ДНК случайными нуклеотидами
        self.DNA = [NSMutableArray arrayWithCapacity:self.dnaLength];
        do {
            [_DNA addObject:[Cell getRandomNucleotide]];
        } while ([_DNA count] < self.dnaLength);
    }
}

- (NSString *)description {
    return [_DNA componentsJoinedByString:@""];
}

- (NSUInteger)hammingDistance:(Cell *)cellToCompare {
    // сравниваем нуклеотиды в одинаковых позициях
    // и подсчитываем количество несовпадений
    NSUInteger mismatches = 0;
    for (NSUInteger i = 0; i < self.dnaLength; i++) {
        if (![[_DNA objectAtIndex:i] isKindOfClass:[NSString class]]) {
            [NSException raise:@"object has wrong type" 
                        format:@"object in _DNA at position %d has wrong type", i];
        } else if (![[cellToCompare->_DNA objectAtIndex:i] isKindOfClass:[NSString class]]) {
            [NSException raise:@"object has wrong type" 
                        format:@"object in cellToCompare->_DNA at position %d has wrong type", i];
        } else if ([_DNA objectAtIndex:i] != [cellToCompare->_DNA objectAtIndex:i]) {
            mismatches++;
        }
    }
    
    // возвращаем кол-во несовпадений
    return mismatches;
}

- (void)mutate:(NSUInteger)mutationPercent {
    
    if (mutationPercent > 100) {
        [NSException raise:@"wrong mutation percent" format:@"mutation percent %lu not allowed", mutationPercent];
    } else {
        // на основе переданного процента мутаций и длины цепи
        // получаем кол-во нуклеотидов для замены, округленное до целого
        NSUInteger numberOfMutation = round(self.dnaLength / 100.0 * mutationPercent);
        
        // инициализируем массив позиций нуклеотидов для замены
        NSMutableArray * mutateIndexes = [NSMutableArray arrayWithCapacity:numberOfMutation];
        
        // создаем массив со всеми возможными позициями
        // и заполняем его натуральными числами
        NSMutableArray * allPositions = [NSMutableArray arrayWithCapacity:self.dnaLength];
        for (NSUInteger i = 0; i < self.dnaLength; i++) {
            [allPositions addObject:[NSNumber numberWithInt:i]];
        }
        
        // случайным образом вытаскиваем из массива allPositions нужное количество позиций
        // и заполняем ими массив mutateIndexes
        NSUInteger randomPosition;
        for (NSUInteger i = 0; i < numberOfMutation; i++) {
            randomPosition = arc4random() % [allPositions count];
            [mutateIndexes addObject:[allPositions objectAtIndex:randomPosition]];
            [allPositions removeObjectAtIndex:randomPosition];
        }
        
        // заменяем нуклеотиды в позициях из полученного массива mutateIndexes
        while ([mutateIndexes count] > 0) {
            [self changeNucleotideAtPosition:[[mutateIndexes lastObject] intValue]];
            [mutateIndexes removeLastObject];
        }
    }
}

- (void)changeNucleotideAtPosition:(NSUInteger)index {
    // вытаскиваем текущий нуклеотид в позиции index
    NSString * currentNucleotide = [_DNA objectAtIndex:index];
    
    // создаем массив альтернативных нуклеотидов из трех элементов
    // (исключаем текущий нуклеотид из стандартного набора)
    NSMutableArray * alternativeNucleotides = [NSMutableArray arrayWithCapacity:3];
    NSString * alternativeNucleotide;
    for (NSUInteger i = 0; i < 4; i++) {
        alternativeNucleotide = [NSString stringWithFormat:@"%c", nucleotides[i]];
        if (alternativeNucleotide != currentNucleotide) {
            [alternativeNucleotides addObject:alternativeNucleotide];
        }
    }
    
    // из полученного массива вытаскиваем случайным образом
    // альтернативный нуклеотид и заменяем им текущий в нужной позиции
    NSUInteger randomIndex = arc4random() % 3;
    [_DNA replaceObjectAtIndex:index 
                    withObject:[alternativeNucleotides objectAtIndex:randomIndex]];
}

- (Cell *)crossingHaflByHalfWithCell:(Cell *)cell {
    Cell * newCell = [[Cell alloc] init];
    newCell.dnaLength = self.dnaLength;
    newCell.DNA = [NSMutableArray arrayWithCapacity:self.dnaLength];
    NSUInteger half = round(self.dnaLength / 2.0);
    NSString * nucleotide;
    for (NSUInteger i = 0; i < self.dnaLength; i++) {
        if (i < half) {
            nucleotide = [NSString stringWithFormat:@"%@", [_DNA objectAtIndex:i]];
        } else {
            nucleotide = [NSString stringWithFormat:@"%@", [cell->_DNA objectAtIndex:i]];
        }
        [newCell->_DNA addObject:nucleotide];
    }
    return newCell;
}

- (Cell *)crossingEvenOddWithCell:(Cell *)cell {
    Cell * newCell = [[Cell alloc] init];
    newCell.dnaLength = self.dnaLength;
    newCell.DNA = [NSMutableArray arrayWithCapacity:self.dnaLength];
    NSString * nucleotide;
    for (NSUInteger i = 0; i < self.dnaLength; i++) {
        if (i % 2) {
            nucleotide = [NSString stringWithFormat:@"%@", [_DNA objectAtIndex:i]];
        } else {
            nucleotide = [NSString stringWithFormat:@"%@", [cell->_DNA objectAtIndex:i]];
        }
        [newCell->_DNA addObject:nucleotide];
    }
    return newCell;
}

- (Cell *)crossing206020WithCell:(Cell *)cell {
    Cell * newCell = [[Cell alloc] init];
    newCell.dnaLength = self.dnaLength;
    newCell.DNA = [NSMutableArray arrayWithCapacity:self.dnaLength];
    NSString * nucleotide;
    NSUInteger percent;
    for (NSUInteger i = 0; i < self.dnaLength; i++) {
        percent = round((i + 1) * 100.0 / self.dnaLength);
        if (percent <= 20 || 80 < percent) {
            nucleotide = [NSString stringWithFormat:@"%@", [_DNA objectAtIndex:i]];
        } else {
            nucleotide = [NSString stringWithFormat:@"%@", [cell->_DNA objectAtIndex:i]];
        }
        [newCell->_DNA addObject:nucleotide];
    }
    return newCell;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.DNA forKey:@"DNA"];
    [aCoder encodeInteger:self.dnaLength forKey:@"dnaLength"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.DNA = [aDecoder decodeObjectForKey:@"DNA"];
        self.dnaLength = [aDecoder decodeIntegerForKey:@"dnaLength"];
    }
    return self;
}

@end
