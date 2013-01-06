//
//  IDNPopulation.m
//  IDNA
//
//  Created by Dmitriy Zhukov on 07.01.13.
//  Copyright (c) 2013 Dmitriy Zhukov. All rights reserved.
//

#import "IDNPopulation.h"
#import "IDNCell.h"

@implementation IDNPopulation

- (id)initWithPopulation:(NSInteger)aPopulation andDNALength:(NSInteger)aDNALenght { //Инициация массива с заданным размером
    self = [super init];
    if (self) {
        _bestDistanseToTarget = 0;
        _idealDNAstatus = NO;
        _population = [[NSMutableArray alloc]initWithCapacity:aPopulation];
        for (int i = 0; i < aPopulation; i++) {
            IDNCell* unicDNA = [[IDNCell alloc]init];
            [unicDNA fillDNAArrayWithCapacity:aDNALenght];
            [_population addObject:unicDNA];
        }
    }
    return self;
}

- (void) searchAndSortPopulationByHummingDistanceTo:(IDNCell*)aGoalDNA {
    
    //Проставляем хамминг дистанс для элементов массива
    for (IDNCell *uDNA in _population) {
        uDNA.unitDistanceToTargetDNA= [aGoalDNA hammingDistance:uDNA];
    }
    
    //Сортируем массив по хамминг дистанс
    _population = [NSMutableArray arrayWithArray: [_population sortedArrayUsingComparator: ^(IDNCell* obj1, IDNCell* obj2) {
        
        NSInteger a = [obj1 unitDistanceToTargetDNA];
        NSInteger b = [obj2 unitDistanceToTargetDNA];
        
        if (a > b) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (b < a) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }]];
    
    //Проверяем, есть ли среди в массиве идеальная днк
    _bestDistanseToTarget = [[_population objectAtIndex:0] unitDistanceToTargetDNA];
    
    if (_bestDistanseToTarget==0) {
        _idealDNAstatus = YES;
    } else {
        _idealDNAstatus = NO;
    }
}

- (void) crossingBestDNA {
    
    //Выборка 50% массива.
    NSInteger numberOfBestCells = ([_population count]*50)/100; //первые 50 % ячеек
    NSInteger numberOfLastCells = ([_population count]-numberOfBestCells); //это те ячейки которые нужно заменить
    
    //Создаем массив с изменениями днк для худших особей
    NSMutableArray *crossDNA = [[NSMutableArray alloc]initWithCapacity:numberOfLastCells];
    
    for (int i = 0 ; i < numberOfLastCells; i++) { //прогоняем алгоритм столько раз, сколько ячеек нужно заменить
        
        //Генерируем два случайных неодинаковых индекса в интервале от 0 до numberOfBestCells
        
        NSInteger indexM = arc4random ()%numberOfBestCells;
        NSInteger indexF;
        
        for(;;){
            indexF = arc4random ()%numberOfBestCells;
            if (indexF != indexM) {
                break;
            }}
        
        //Выбор одного из трех алгоритмoв скрещивания
        switch (arc4random ()%3) {
                //Метод 50 на 50
            case 0:
                [crossDNA addObject:[self halfByHalfCrossing:[_population objectAtIndex:indexM]with:[_population objectAtIndex:indexF]]];
                break;
            case 1:
                [crossDNA addObject:[self oneByOneCrossing:[_population objectAtIndex:indexM]with:[_population objectAtIndex:indexF]]];
                break;
            case 2:
                [crossDNA addObject:[self partsCrossing:[_population objectAtIndex:indexM]with:[_population objectAtIndex:indexF]]];
                break;
        }
    }
    for(NSInteger i = numberOfBestCells; i < [_population count]; i++) {
        NSInteger crossIndex = i-numberOfBestCells;  //проверить
        [_population replaceObjectAtIndex:i withObject:[crossDNA objectAtIndex:crossIndex]];
    }
}





- (IDNCell*) halfByHalfCrossing:(IDNCell*)firstCell with:(IDNCell*)secondCell {
    
    NSInteger DNALengthInPopulation = [[firstCell valueForKey:@"DNA"]count];
    IDNCell* unDNA = [[IDNCell alloc]init];
    
    NSInteger n1 = (DNALengthInPopulation *50)/100; //колличество клеток первого родителя
    NSInteger n2 = (DNALengthInPopulation-n1); //колличество клеток второго родителя
    
    for (int i = 0 ; i < n1; i++) {
        [unDNA.DNA addObject:[firstCell.DNA objectAtIndex:i]];
    }
    
    for (int i = 0 ; i < n2; i++) {
        [unDNA.DNA addObject:[secondCell.DNA objectAtIndex:i]];
    }
    
    return unDNA;
}



- (IDNCell*) oneByOneCrossing:(IDNCell*)firstCell with:(IDNCell*)secondCell {
    
    NSInteger DNALengthInPopulation = [[firstCell valueForKey:@"DNA"]count];
    IDNCell* unDNA = [[IDNCell alloc]init];
    
    for (int i = 0 ; i < DNALengthInPopulation; i++) {
        if (i & 1) {
            [unDNA.DNA addObject:[firstCell.DNA objectAtIndex:i]];
            //NSLog(@"even %@",unDNA.DNA);
        } else {
            [unDNA.DNA addObject:[secondCell.DNA objectAtIndex:i]];
            //NSLog(@"odd %@",unDNA.DNA);
        }
    }
    
    return unDNA;
}



- (IDNCell*) partsCrossing:(IDNCell*)firstCell with:(IDNCell*)secondCell {
    
    NSInteger DNALengthInPopulation = [[firstCell valueForKey:@"DNA"]count];
    IDNCell* unDNA = [[IDNCell alloc]init];
    
    NSInteger n1 = (DNALengthInPopulation *60)/100; //колличество клеток первого родителя
    NSInteger n2 = (DNALengthInPopulation-n1)/2; //первые 20%
    
    for (int i = 0 ; i < n2; i++) {
        [unDNA.DNA addObject:[firstCell.DNA objectAtIndex:i]];
    }
    
    for (int i = 0 ; i < n1; i++) {
        [unDNA.DNA addObject:[secondCell.DNA objectAtIndex:i]];
    }
    
    for (NSInteger i = n1+n2; i < DNALengthInPopulation; i++) {
        [unDNA.DNA addObject:[firstCell.DNA objectAtIndex:i]];
    }
    
    return unDNA;
}



- (void) populationMutate: (NSInteger)percentage {
    
    for (IDNCell *cell in _population) {
        [cell mutate:percentage];
    }
}


@end
