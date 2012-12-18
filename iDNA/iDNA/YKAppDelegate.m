//
//  YKAppDelegate.m
//  iDNA
//
//  Created by Yuri Kirghisov on 12.12.12.
//  Copyright (c) 2012 Yuri Kirghisov. All rights reserved.
//

#import "YKAppDelegate.h"

@implementation YKAppDelegate

- (YKAppDelegate *)init
{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"dnaLength" options:0 context:nil];
        [self addObserver:self forKeyPath:@"minimumHammingDistance" options:0 context:nil];

        self.populationSize = 20;
        self.dnaLength = 30;
        self.mutationRate = 13;

        self.population = [NSMutableArray array];
        self.generation = 0;
        self.minimumHammingDistance = nil;

        // Generate new Goal DNA
        self.goalDNA = [[YKDNA alloc] initWithLength:self.dnaLength];
    }

    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"dnaLength"];
    [self removeObserver:self forKeyPath:@"minimumHammingDistance"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.isFirstRun = YES;
    self.isBusy = NO;
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

    // 2. Остановить эволюцию если есть ДНК, полностью совпадающее с Goal DNA (hamming distance == 0)

    if (self.population.count > 0) {
        NSUInteger minHammingDistance = [[self.population objectAtIndex:0] hammingDistanceToDNA:self.goalDNA];
        self.minimumHammingDistance = [NSNumber numberWithUnsignedInteger:minHammingDistance];

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
}

- (void)runEvolution
{
    while (!self.isGoalReached && self.isBusy && self.generation<50) {
        self.generation++;
//        [self performSelectorInBackground:@selector(performEvolutionIteration) withObject:nil];
        [self performEvolutionIteration];
//        [self pauseButtonPressed:nil];
    }

    self.isBusy = NO;
}

#pragma mark -
#pragma mark Delegate Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self) && keyPath) {
        if ([keyPath isEqualToString:@"dnaLength"]) {
            self.goalDNA = [[YKDNA alloc] initWithLength:self.dnaLength];
        } else if ([keyPath isEqualToString:@"minimumHammingDistance"]) {
            NSNumber *newValue = self.minimumHammingDistance;
            if (newValue && self.dnaLength > 0) {
                NSLog (@"Setting percentageComplete to %lu", 100-100*[newValue unsignedIntegerValue]/self.dnaLength);
                self.percentageComplete = 100-100*[newValue unsignedIntegerValue]/self.dnaLength;
            } else
                self.percentageComplete = 0;
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
        
        self.isGoalReached = NO;
        self.generation = 0;

        self.isFirstRun = NO;
    }
    
    // Инициализируем эволюцию
    self.window.title = @"iDNA in progress…";
    self.isBusy = YES;

    // Запускаем эволюцию
    [self runEvolution];
}

- (IBAction)pauseButtonPressed:(id)sender
{
    self.window.title = @"iDNA";
    self.isBusy = NO;
}

- (IBAction)loadGoalDnaButtonPressed:(id)sender
{
    NSLog (@"loadGoalDnaButtonPressed:");
}

@end
