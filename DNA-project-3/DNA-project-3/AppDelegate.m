//
//  AppDelegate.m
//  DNA-project-3
//
//  Created by Sergey on 22.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Cell.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize goalDNATextField;
@synthesize pauseButton;
@synthesize startButton;
@synthesize loadButton;
@synthesize populationSizeTextField;
@synthesize dnaLengthTextField;
@synthesize mutationRateTextField;
@synthesize populationSizeSlider;
@synthesize dnaLengthSlider;
@synthesize mutationRateSlider;

@synthesize generationTextField;
@synthesize bestMatchTextField;

static void *RMDocumentKVOContext;

-(id)init {
    self = [super init];
    if (self) {
        undoManager = [[NSUndoManager alloc] init];
        NSLog(@"OKKKKK");
        [self addObserver:self forKeyPath:@"populationSize" options:0 context:&RMDocumentKVOContext];
        [self addObserver:self forKeyPath:@"dnaLength" options:0 context:&RMDocumentKVOContext];
        [self addObserver:self forKeyPath:@"mutationRate" options:0 context:&RMDocumentKVOContext];
        [self addObserver:self forKeyPath:@"test" options:0 context:&RMDocumentKVOContext];
    }
    return self;
}
-(void)changeKeyPath:(NSString*)keyPath
           ofObject:(id)obj
            toValue:(id)newValue {
    [obj setValue:newValue forKeyPath:keyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        NSLog(@"oldValue=%@",oldValue);
    if (oldValue == [NSNull null])
        oldValue = nil;
    NSLog(@"keyPath=%@",keyPath);
    [[undoManager prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"populationSize"];
    [self removeObserver:self forKeyPath:@"dnaLength"];
    [self removeObserver:self forKeyPath:@"mutationRate"];
    [self removeObserver:self forKeyPath:@"test"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self willChangeValueForKey:@"populationSize"];
    populationSize = DEFAULTPOPULATIONSIZE;
    [self didChangeValueForKey:@"populationSize"];
    
    [self willChangeValueForKey:@"dnaLength"];
    dnaLength = DEFAULTDNALENGTH;    
    [self didChangeValueForKey:@"dnaLength"];
    
    [self willChangeValueForKey:@"mutationRate"];    
    mutationRate = DEFAULTMUTATIONRATE;
    [self didChangeValueForKey:@"mutationRate"];

    [self willChangeValueForKey:@"generation"];
    generation = 0;
    [self didChangeValueForKey:@"generation"];
    
    goalDNA = [[Cell alloc] init ];
    [goalDNA initWithDNALenght:dnaLength];    
    [goalDNATextField setStringValue:[goalDNA stringDNA]];   
    
    population = [[NSMutableArray alloc] init];
    startEvolution = NO;
}

-(void)setPopulationSize:(int) x {
    populationSize = x;
}

-(NSInteger)populationSize  {
    return populationSize;
}

-(void)setDnaLength:(int) x {
    dnaLength = x;
    [goalDNA initWithDNALenght:dnaLength];    
    [goalDNATextField setStringValue:[goalDNA stringDNA]];   
}

-(NSInteger)dnaLength{
    return dnaLength;
}

-(void)setMutationRate:(int) x {
    mutationRate = x;    
}

-(NSInteger)mutationRate {
    return mutationRate;
}

-(void)setGeneration:(int) x {
    generation = x;
}

-(NSInteger)generation {
    return generation;
}

-(void)setBestHammingDistance:(NSInteger)x {
    bestHammingDistance = x;
}

-(NSInteger)bestHammingDistance {
    return bestHammingDistance;
}


-(void)setVisible:(BOOL) v {
    [populationSizeTextField setEnabled:!v];
    [dnaLengthTextField setEnabled:!v];
    [mutationRateTextField setEnabled:!v];
    
    [populationSizeSlider setEnabled:!v];
    [dnaLengthSlider setEnabled:!v];
    [mutationRateSlider setEnabled:!v];
    
    [loadButton setEnabled:!v];
    [startButton setEnabled:!v];
    
    /*3. сделать активной кнопку Pause. */
   [pauseButton setEnabled:v];
    
}

-(void)processEvolution{
    startEvolution = YES;
    [self setVisible:startEvolution];
    
    [self willChangeValueForKey:@"generation"];
    generation = 0;
    [self didChangeValueForKey:@"generation"];
    

    /*2. сделать неактивными (disabled) три первых text field'а и их ползунки,
     а также кнопки "Start evolution" и "Load goal DNA"*/

    /*1. создать случайную популяцию ДНК. Размер популяции = значение первого text field'а.
     Размер каждого ДНК = значение второго text field'а.*/

    [population removeAllObjects]; //
    // заполняем новыми популяциями
    for (int i=0; i<populationSize; i++) {
        Cell* myCell = [[Cell alloc] init];
        [myCell initWithDNALenght:dnaLength];
        [population addObject:myCell];
    }
    /*4. начать эволюцию.*/
    while (startEvolution == YES) {
        [self willChangeValueForKey:@"generation"];
        generation++;
        [self didChangeValueForKey:@"generation"];
        
        
        NSLog(@"генерация = %i",generation);
        //  [generationTextField setStringValue:[NSString stringWithFormat:@"%d", generation]];
        //4.1 Отсортировать популяцию по близости (hamming distance) к Goal DNA
        // вычисляем различия hammingDistance чтобы по нему отсортировать
        for (int i=0; i<populationSize; i++) {
            [[population objectAtIndex:i] calculateHammingDistance:goalDNA];
        }
        // for (int i=0; i<populationSize; i++) {
        //      NSInteger hd = [[population objectAtIndex:i] hammingDistance];
        //NSLog(@"%d = %ld",i,hd);
        //  }
        
        // сортируем объекты с массиве population по значению  hammingDistance
        // создаем объект класса NSSortDescriptor, который будет использоваться для сортировки
        NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hammingDistance" ascending:YES comparator:^(id obj1, id obj2) {
        
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        // непостредственно сортируем массив, используя ранее созданные десктрипторы
        NSMutableArray* sortedArray = [NSMutableArray arrayWithArray:[population sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]] ];
        [population removeAllObjects];
        for (int i=0; i<populationSize; i++) {
            [population addObject:[sortedArray objectAtIndex:i]];
        }

      //  population = sortedArray;
        //       for (int i=0; i<populationSize; i++) {
        //         NSInteger hd = [[population objectAtIndex:i] hammingDistance];
        //    NSLog(@"%d = %ld",i,hd);
        //    }
    
        //4.2 Остановить эволюцию если есть ДНК полностью совпадающее с Goal DNA (hamming distance = 0)
        // вычисляем различия hammingDistance чтобы по нему отсортировать
        [self willChangeValueForKey:@"bestHammingDistance"];
        bestHammingDistance = 100 - [[population objectAtIndex:0] hammingDistance];
        [self didChangeValueForKey:@"bestHammingDistance"];
        
        if (bestHammingDistance == 100) {
            startEvolution = NO;
            [self setVisible:startEvolution];
            return;
        }
    
        //4.3 Скрестить кандидатов из топ 50% и заменить результатом оставшиеся 50%.
        //4.3.1 Взять два случайных ДНК
        for (int i=populationSize/2; i<populationSize; i++) {
            //NSLog(@"%d", i);
            int num_int1 = arc4random() % dnaLength / 2;  // 1 из топ 50%
            int num_int2 = arc4random() % dnaLength / 2;  // 2 из топ 50%
            // смотрим чтобы ячейки не совпали
            while (num_int1 == num_int2)
                num_int2 = arc4random() % dnaLength / 2;  // 2 из топ 50%
            //4.3.2 Скомбинировать их содержание чтобы получить новую ДНК.
            NSMutableArray* NewDNA = [[NSMutableArray alloc]init];
            NewDNA = [[population objectAtIndex:num_int1] crossing:[population objectAtIndex:num_int2]];
            [[[population objectAtIndex:i] DNA] removeAllObjects];
            [[[population objectAtIndex:i] DNA] addObjectsFromArray:NewDNA];
            //      NSLog(@"---%lu", [[[population objectAtIndex:i] DNA]count]);
            //            [population replaceObjectAtIndex:i withObject:NewCell];
        }
    
        //4.4 Мутировать популяцию (как в проекте 1) используя значение процента мутирования из третьего text field'а.
        for (int i=0; i<=populationSize-1; ++i)
            [[population objectAtIndex:i] mutate:mutationRate];
    
    }
}


- (IBAction)startEvolution:(id)sender {
     [self performSelectorInBackground:@selector(processEvolution) withObject:nil];//стартуем новый поток
  }

- (IBAction)pauseEvolution:(id)sender {
    startEvolution = NO;
    //Эволюция идет пока не нажата кнопка Pause ИЛИ пока не достигнута цель эволюции.
    [self setVisible:startEvolution];
}

- (IBAction)loadGoalDNA:(id)sender {
    test = test + 10;
    NSLog(@"test=%ld",test);
    
}
@end
