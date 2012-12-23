//
//  YKAppDelegate.m
//  iDNA
//
//  Created by Yuri Kirghisov on 12.12.12.
//  Copyright (c) 2012 Yuri Kirghisov. All rights reserved.
//

// Особенности реализации (надеюсь, сбережет несколько минут времени проверяющего).
//
// 1. Реализация интерфейса должна быть прозрачной, без изысков:
// 1.1. Включение и выключение элементов интерфейса производится привязкой их свойства isEnabled к свойству данного объекта isBusy.
//
// 2. Просчет поколений в цикле (в основном потоке) заблокировал бы пользовательский интерфейс. Выполнение всего цикла в отдельном потоке также нецелесообразно ввиду большого количества изменений (массив population изменяется очень сильно), т.е. передавать его в параметрах накладно и долго. Поэтому решение следующее:
//  2.1. Нажатие кнопки Start Evolution выполняет метод runEvolution.
//  2.2 Метод runEvolution проверяет условия окончания просчета. Если цель не достигнута и пользователь не остановил просчет, запускаем выполнение метода performEvolutionIteration в отдельном потоке.
//  2.3. По окончании выполнения метод performEvolutionIteration посылает в основной поток уведомление YKEvolutionIterationDidFinishNotification, после чего завершает свою работу.
//  2.4. Метод evolutionIterationDidFinish: в основном потоке получает уведомление и выполняет снова метод runEvolution.

#import "YKAppDelegate.h"

@implementation YKAppDelegate

#define EVOLUTION_ITERATION_DID_FINISH_NOTIFICATION_NAME @"YKEvolutionIterationDidFinishNotification"

- (YKAppDelegate *)init
{
    self = [super init];
    if (self) {
        // Регистрируем наблюдение для адекватного реагирования на изменения этих полей в UI
        [self addObserver:self forKeyPath:@"populationSize" options:0 context:nil];
        [self addObserver:self forKeyPath:@"dnaLength" options:0 context:nil];
        [self addObserver:self forKeyPath:@"minimumHammingDistance" options:0 context:nil];

        // Значения по умолчанию. Хранение в пользовательских настройках условиями задания не требуется.
        self.populationSize = 20;
        self.dnaLength = 30;
        self.mutationRate = 13;

        // Инициализация прочих свойств
        self.population = [NSMutableArray array];
        self.generation = 0;
        self.minimumHammingDistance = self.dnaLength;
        self.bestIndividualMatch = 0;

        // Создаем новую Goal DNA
        self.goalDNA = [[YKDNA alloc] initWithLength:self.dnaLength];
    }

    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"populationSize"];
    [self removeObserver:self forKeyPath:@"dnaLength"];
    [self removeObserver:self forKeyPath:@"minimumHammingDistance"];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVOLUTION_ITERATION_DID_FINISH_NOTIFICATION_NAME object:nil];
 }

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.isFirstRun = YES;
    self.isBusy = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(evolutionIterationDidFinish:) name:EVOLUTION_ITERATION_DID_FINISH_NOTIFICATION_NAME object:nil];
}

- (void)goalIsReached
{
    self.isGoalReached = YES;
    self.isBusy = NO;
}

- (void)updateStatus
{
    self.isGoalReached = YES;
    self.isBusy = NO;
}

- (void)performEvolutionIteration
{
    self.generation++;
    
    // 1. Отсортировать популяцию по близости (hamming distance) к Goal DNA

    [self.population sortUsingComparator:^(YKDNA *dna1, YKDNA *dna2) {
        // Этот блок сравнивает hamming distance двух элементов массива и результат используется для сортировки
        NSUInteger hammingDistance1 = [dna1 hammingDistanceToDNA:self.goalDNA];
        NSUInteger hammingDistance2 = [dna2 hammingDistanceToDNA:self.goalDNA];

        if (hammingDistance1 < hammingDistance2)
            return (NSComparisonResult)NSOrderedAscending;

        if (hammingDistance1 > hammingDistance2)
            return (NSComparisonResult)NSOrderedDescending;

        return (NSComparisonResult)NSOrderedSame;
    }];

    // 2. Остановить эволюцию, если есть ДНК, полностью совпадающее с Goal DNA (hamming distance == 0)

    if (self.population.count > 0) {
        NSUInteger minHammingDistance = [[self.population objectAtIndex:0] hammingDistanceToDNA:self.goalDNA];
        self.minimumHammingDistance = minHammingDistance;

        if (minHammingDistance == 0) {
        // Как минимум первая ДНК (с минимальным hamming distance) совпала с Goal DNA. Ура, товарищи! Красиво съезжаем.
//            [self isGoalReached];
            [self performSelectorOnMainThread:@selector(goalIsReached) withObject:nil waitUntilDone:YES];
            return;
        }
    }

    // 3. Скрестить кандидатов из топ 50% и заменить результатом оставшиеся 50%.

    // 3.1. Берем две случайные ДНК
    int r1 = arc4random_uniform(self.population.count/2);
    int r2 = arc4random_uniform(self.population.count/2);
    YKDNA *dna1 = [self.population objectAtIndex:r1];
    YKDNA *dna2 = [self.population objectAtIndex:r2];
    
    // 3.2. Скрещиваем
    YKDNA *breededDNA = [dna1 dnaByBreedingWithDNA:dna2];

    // И заменяем результатом оставшиеся 50%
    for (NSUInteger i=self.population.count/2; i<self.population.count; i++) {
        [self.population replaceObjectAtIndex:i withObject:breededDNA];
    }
    
    // 4. Мутировать популяцию, используя значение процента мутирования из третьего text field'а.

    for (YKDNA *dna in self.population) {
        [dna mutateWithPercentage:self.mutationRate];
    }

    // Посылаем уведомление об окончании шага эволюции, чтобы запустить следующий шаг из основного потока
    [[NSNotificationCenter defaultCenter] postNotificationName:EVOLUTION_ITERATION_DID_FINISH_NOTIFICATION_NAME object:self];
}

- (void)runEvolution
{
    if (!self.isGoalReached && self.isBusy) {
        self.isBusy = YES;

        // Выполняем performEvolutionIteration в фоновом потоке, чтобы не блокировать элементы пользовательского интерфейса в основном потоке
        [self performSelectorInBackground:@selector(performEvolutionIteration) withObject:nil];
    }
}

#pragma mark -
#pragma mark Listening Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self) && keyPath) {

        if ([keyPath isEqualToString:@"populationSize"]) {

            // При изменении self.populationSize перезапускаем эволюцию
            self.isFirstRun = YES;

        } else if ([keyPath isEqualToString:@"dnaLength"]) {

            // При изменении self.dnaLength создаем новую Goal DNA и перезапускаем эволюцию
            self.goalDNA = [[YKDNA alloc] initWithLength:self.dnaLength];
            self.isFirstRun = YES;

        } else if ([keyPath isEqualToString:@"minimumHammingDistance"]) {

            // При изменении self.minimumHammingDistance изменяем и self.bestIndividualMatch для правильного отображения индикатора выполнения в интерфейсе
            if (self.dnaLength > 0) {
                NSUInteger newIndividualMatch = 100-100*self.minimumHammingDistance/self.dnaLength;
                if (newIndividualMatch > self.bestIndividualMatch)
                    self.bestIndividualMatch = newIndividualMatch;
            }

        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)evolutionIterationDidFinish:(NSNotification *)aNotification
{
    // Это уведомление отправляется по окончании каждого шага эволюции
    if (aNotification && [[aNotification name] isEqualToString:EVOLUTION_ITERATION_DID_FINISH_NOTIFICATION_NAME]) {
        [self runEvolution];
    }
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)startEvolutionButtonPressed:(id)sender
{
    if (self.isFirstRun) {
        // Генерируем несколько ДНК количеством self.populationSize
        NSMutableArray *newPopulation = [NSMutableArray arrayWithCapacity:self.populationSize];
        for (NSUInteger i=0; i<self.populationSize; i++) {
            YKDNA *newDNA = [[YKDNA alloc] initWithLength:self.dnaLength];
            [newPopulation addObject:newDNA];
        }
        self.population = newPopulation;
        
        // Инициализируем эволюцию
        self.isGoalReached = NO;
        self.generation = 0;
        self.bestIndividualMatch = 0;
        self.isFirstRun = NO;
    }
    
    // Запускаем эволюцию
    self.window.title = @"iDNA in progress…";
    self.isBusy = YES;
    [self runEvolution];
}

- (IBAction)pauseButtonPressed:(id)sender
{
    // Приостанавиваем эволюцию
    self.window.title = @"iDNA";
    self.isBusy = NO;
}

- (IBAction)loadGoalDnaButtonPressed:(id)sender
{
    // Задание так и не объясняет необходимость этой кнопки, так что оставляем пустышку.
    NSLog (@"loadGoalDnaButtonPressed:");
}

@end
