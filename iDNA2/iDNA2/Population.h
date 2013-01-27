//
//  Population.h
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 03.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@interface Population : NSObject <NSCoding>

// размер популяции
@property NSUInteger populationSize;
// длина ДНК у клеток популяции
@property NSUInteger dnaLength;
// процент мутации
@property NSUInteger mutationRate;
// поколение
@property NSUInteger generation;
// конечная ДНК
@property Cell * goalDNA;
// популяция
@property NSMutableArray * populationCells;
// приостановить эволюцию
@property BOOL evolutionPaused;

// статический метод для создания популяции с заданными параметрами
+ (Population *)createPopulationWithData:(NSDictionary *)data;

// метод для выполнения одного шага эволюции,
// возвращает процент совпадения с конечной ДНК
// для самой удачной клетки
- (NSDictionary *)oneStepEvolution;

// метод устанавливает расстояние Хэмминга с конечной ДНК
// у всех клеток популяции
- (void)calculateHammingDistance;

// метод сортирует клетки популяции по расстоянию Хэмминга
- (void)sortByHammingDistance;

// метод находит кол-во клеток с таким же расстоянием Хэмминга
// как у первой клетки
- (NSUInteger)bestCellsCount;

// метод для скрещивания половины клеток
- (void)halfCrossing;

// метод для мутации популяции
- (void)mutate;

@end
