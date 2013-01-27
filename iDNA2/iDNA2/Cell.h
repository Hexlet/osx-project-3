//
//  Cell.h
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 03.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// константа класса, хранит имена возможных нуклеотидов
static const char nucleotides[] = "GATC";

@interface Cell : NSObject <NSCoding>

// свойство dnaLength хранит длину цепи нуклеотдиов в клетке
@property NSUInteger dnaLength;

// свойство DNA хранит цепь нуклеотидов
// в виде массива объектов NSString
@property NSMutableArray * DNA;

// расстояние Хэмминга с конечной клеткой
@property NSUInteger hammingDistanceWithGoalDna;

// статический метод для получения случайного нуклеотида
+ (NSString *)getRandomNucleotide;

// статический метод для получения ДНК с заданной цепью нуклеотидов
+ (Cell *)getCellWithDna:(NSString *)dna;

// статический метод для получения случайной ДНК заданной длины
+ (Cell *)getCellWithDnaLength:(NSUInteger)dnaLength;

// метод для получения новой клетки из двух имеющихся клеток
// случайным методом скрещивания
+ (Cell *)randomlyCrossingMom:(Cell *)mom andDad:(Cell *)dad;

// метод получает строку и проверяет может ли данная строка
// обозначать цепь нуклеотидов
+ (BOOL)dnaIsCorrect:(NSString *)dnaString;

// генерацию произвольной цепи нуклеотидов вынесем в отдельный метод
// данный метод нам будет нужен только при инициализации объекта,
// поэтому он должен вызываться для одного объекта только один раз
- (void)fillDnaOnce;

// данный метод сравнивает цепь нукеотидов в текущем объекте
// с цепью в переданном объекте
// и возвращает количество расхождений
- (NSUInteger)hammingDistance:(Cell *)cellToCompare;

// метод трансформирует цепь нуклеотидов (поле DNA)
// заменяя в нем произвольным образом ровно x нуклеотидов
- (void)mutate:(NSUInteger)percentOfMutation;

// метод находит нуклеотид с заданными индексом
// и заменяет его на какой-то другой
- (void)changeNucleotideAtPosition:(NSUInteger)index;

// метод для получения новой клетки при скрещивании
// с дополнительной клеткой; новая клетка унаследует 
// по половине цепи ДНК от каждого из родителей
- (Cell *)crossingHaflByHalfWithCell:(Cell *)cell;

// метод для получения новой клетки при скрещивании
// с дополнительной клеткой; новая клетка возьмет
// четные нуклеотиды от одного родителя и нечетные от другого
- (Cell *)crossingEvenOddWithCell:(Cell *)cell;

// метод для получения новой клетки при скрещивании
// с дополнительной клеткой; новая клетка возьмет
// 40% нуклеотидов от одного родителя (по краям)
// и 60% от другого (в центре)
- (Cell *)crossing206020WithCell:(Cell *)cell;

@end
