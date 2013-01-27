//
//  Population.m
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 03.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Population.h"
#import "ui.h"

@implementation Population

@synthesize populationSize = _populationSize;
@synthesize dnaLength = _dnaLength;
@synthesize mutationRate = _mutationRate;
@synthesize generation = _generation;
@synthesize goalDNA = _goalDNA;
@synthesize populationCells = _populationCells;
@synthesize evolutionPaused = _evolutionPaused;

+ (Population *)createPopulationWithData:(NSDictionary *)data {
    Population * newPopulation = [[super alloc] init];
    if (newPopulation) {
        newPopulation.populationSize = [[data objectForKey:@"populationSize"] intValue];
        newPopulation.dnaLength = [[data objectForKey:@"dnaLength"] intValue];
        newPopulation.mutationRate = [[data objectForKey:@"mutationRate"] intValue];
        newPopulation.generation = 0;
        newPopulation.goalDNA = [data objectForKey:@"goalDna"];
        newPopulation.populationCells = [NSMutableArray arrayWithCapacity:newPopulation.populationSize];
        newPopulation.evolutionPaused = NO;
        Cell * newCell;
        do {
            newCell = [Cell getCellWithDnaLength:newPopulation.dnaLength];
            [newPopulation->_populationCells addObject:newCell];
        } while ([newPopulation->_populationCells count] < newPopulation.populationSize);
    }
    return newPopulation;
}

- (NSDictionary *)oneStepEvolution {
    float bestMatch;
    NSUInteger bestCells;
    // перед сортировкой считаем расстояние Хэмминга у клеток всей популяции
    [self calculateHammingDistance];

    // сортируем популяцию по расстоянию Хэмминга
    [self sortByHammingDistance];

    // после сортировки проверяем, совпадает ли первый элемент с конечной ДНК
    Cell * firstCell = [_populationCells objectAtIndex:0];
    if (firstCell.hammingDistanceWithGoalDna == 0) {
        // мы нашли конечную ДНК!
        bestMatch = 100.0;
    } else {
        bestMatch = (self.dnaLength - firstCell.hammingDistanceWithGoalDna) * 100.0 / self.dnaLength;
        // скрещиваем первые 50% клеток
        [self halfCrossing];
        // мутируем всю популяцию
        [self mutate];
    }
    // сколько клеток с таким же расстоянием Хэмминга
    bestCells = [self bestCellsCount];
    
    // формируем ответ
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithFloat:bestMatch], @"bestMatch",
                           [NSNumber numberWithInt:bestCells], @"bestCells",
                           [NSNumber numberWithInt:self.generation], @"generation",
                           nil];
    self.generation += 1;
    return data;
}

- (void)calculateHammingDistance {
    for (Cell *cell in self.populationCells) {
        cell.hammingDistanceWithGoalDna = [cell hammingDistance:self.goalDNA];
    }
}

- (void)sortByHammingDistance {
    [_populationCells sortUsingComparator:^NSComparisonResult(Cell * cell1, Cell * cell2) {
        NSUInteger hd1 = cell1.hammingDistanceWithGoalDna;
        NSUInteger hd2 = cell2.hammingDistanceWithGoalDna;
        if (hd1 > hd2) {
            return NSOrderedDescending;
        } else if (hd1 < hd2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
}

- (NSUInteger)bestCellsCount {
    // предполагаем, что массив отсортирован по расстоянию Хэмминга
    Cell * firstCell = [_populationCells objectAtIndex:0];
    // ищем остальные
    NSUInteger bestCells = 1;
    for (NSUInteger i = 1; i < self.populationSize; i++) {
        Cell * cell = [_populationCells objectAtIndex:i];
        if (cell.hammingDistanceWithGoalDna == firstCell.hammingDistanceWithGoalDna) {
            bestCells++;
        } else {
            break;
        }
    }
    return bestCells;
}

- (void)halfCrossing {
    NSUInteger half = round(self.populationSize / 2.0);
    // убираем ненужные клетки
    NSRange range = NSMakeRange(half, [_populationCells count] - half);
    [_populationCells removeObjectsInRange:range];
    
    // дополняем массив self.populationCells новыми клетками
    // полученными путем скрещивания
    do {
        if (self.evolutionPaused) {
            usleep(99999);
            continue;
        }
        // получаем два случайных индекса из crossingCells
        // и вместе с ними две случайных клетки
        NSUInteger cellIndex1 = arc4random() % half;
        NSUInteger cellIndex2;
        do {
            cellIndex2 = arc4random() % half;
        } while (cellIndex2 == cellIndex1);
        Cell * cell1 = [_populationCells objectAtIndex:cellIndex1];
        Cell * cell2 = [_populationCells objectAtIndex:cellIndex2];

        // создаем новую клетку
        // и добавляем ее в self.populationCells
        Cell * newCell = [Cell randomlyCrossingMom:cell1 andDad:cell2];
        [_populationCells addObject:newCell];
    } while ([_populationCells count] < self.populationSize);
}

- (void)mutate {
    for (Cell * cell in _populationCells) {
        if (self.evolutionPaused) {
            usleep(99999);
            continue;
        }
        [cell mutate:self.mutationRate];
    }
}

- (NSString *)description {
    NSMutableArray * cellsOutput = [NSMutableArray arrayWithCapacity:[_populationCells count]];
    for (Cell * curCell in _populationCells) {
        NSUInteger hd = curCell.hammingDistanceWithGoalDna;
        [cellsOutput addObject:[NSString stringWithFormat:@"%lu%%\t %@", hd, [curCell description]]];
    }
    return [cellsOutput componentsJoinedByString:@"\n"];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    @try {
        [aCoder encodeInteger:self.populationSize forKey:@"populationSize"];
        [aCoder encodeInteger:self.dnaLength forKey:@"dnaLength"];
        [aCoder encodeInteger:self.mutationRate forKey:@"mutationRate"];
        [aCoder encodeInteger:self.generation forKey:@"generation"];
        [aCoder encodeObject:self.goalDNA forKey:@"goalDNA"];
        [aCoder encodeObject:self.populationCells forKey:@"populationCells"];
        [aCoder encodeBool:self.evolutionPaused forKey:@"evolutionPaused"];
    }
    @catch (NSException *exception) {
        [ui alertDialogWithTitle:@"File save error" andText:@"There is a problem with file saving. It may happen because the evolution is in progress. Try to pause evoultion and save file again."];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.populationSize = [aDecoder decodeIntegerForKey:@"populationSize"];
        self.dnaLength = [aDecoder decodeIntegerForKey:@"dnaLength"];
        self.mutationRate = [aDecoder decodeIntegerForKey:@"mutationRate"];
        self.generation = [aDecoder decodeIntegerForKey:@"generation"];
        self.goalDNA = [aDecoder decodeObjectForKey:@"goalDNA"];
        self.populationCells = [aDecoder decodeObjectForKey:@"populationCells"];
        self.evolutionPaused = [aDecoder decodeBoolForKey:@"evolutionPaused"];
    }
    return self;
}

@end
