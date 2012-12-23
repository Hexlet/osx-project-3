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
    
    goalDNA = [[Cell alloc] init ];
    [goalDNA initWithDNALenght:dnaLength];    
    [goalDNATextField setStringValue:[goalDNA stringDNA]];   
    
    population = [[NSMutableArray alloc] init]; 
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

- (IBAction)startEvolution:(id)sender {
    /*1. создать случайную популяцию ДНК. Размер популяции = значение первого text field'а. 
     Размер каждого ДНК = значение второго text field'а.*/
    [population removeAllObjects]; // удаляем все старые популяции 
    // заполняем новыми популяциями
    for (int i=0; i<populationSize; i++) {
        Cell* myCell = [[Cell alloc] init];
        [myCell initWithDNALenght:dnaLength];
        [population addObject:myCell];        
    }
    /*2. сделать неактивными (disabled) три первых text field'а и их ползунки, 
     а также кнопки "Start evolution" и "Load goal DNA"*/    
    [populationSizeTextField setEnabled:NO];
    [dnaLengthTextField setEnabled:NO];
    [mutationRateTextField setEnabled:NO];
    
    [populationSizeSlider setEnabled:NO];
    [dnaLengthSlider setEnabled:NO];
    [mutationRateSlider setEnabled:NO];
        
    [loadButton setEnabled:NO];    
    [startButton setEnabled:NO];    
    
    /*3. сделать активной кнопку Pause. */
    [pauseButton setEnabled:YES];     
    
    /*4. начать эволюцию.*/
    
    //4.1 Отсортировать популяцию по близости (hamming distance) к Goal DNA
    // вычисляем различия hammingDistance чтобы по нему отсортировать
    for (int i=0; i<populationSize; i++) {
        [[population objectAtIndex:i] calculateHammingDistance:goalDNA];                        
    }

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
    NSMutableArray* sortedArray = [NSMutableArray arrayWithArray:[population sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
    population = sortedArray.copy;

    //4.2 Остановить эволюцию если есть ДНК полностью совпадающее с Goal DNA (hamming distance = 0)
    // вычисляем различия hammingDistance чтобы по нему отсортировать
    for (int i=0; i<populationSize; i++) {
        if ([[population objectAtIndex:i] hammingDistance] == 0) 
            return; // различий нет
        //       NSLog(@"%d = %d", i, currenthammingDistance);
    }

    
   //4.3 Скрестить кандидатов из топ 50% и заменить результатом оставшиеся 50%.    
   //4.3.1 Взять два случайных ДНК
    for (int i=populationSize/2; i<populationSize; i++) {
        
    }
    int num_int = arc4random() % dnaLength / 2;  // топ 50%
    int num_int2 = arc4random() % dnaLength / 2;  //   50%    
    
    
   //4.4 Мутировать популяцию (как в проекте 1) используя значение процента мутирования из третьего text field'а.
    for (int i=0; i<=populationSize-1; ++i)
        [[population objectAtIndex:i] mutate:mutationRate];                
}

- (IBAction)pauseEvolution:(id)sender {
    //Эволюция идет пока не нажата кнопка Pause ИЛИ пока не достигнута цель эволюции.
    [populationSizeTextField setEnabled:YES];
    [dnaLengthTextField setEnabled:YES];
    [mutationRateTextField setEnabled:YES];
    
    [populationSizeSlider setEnabled:YES];
    [dnaLengthSlider setEnabled:YES];
    [mutationRateSlider setEnabled:YES];
    
    [loadButton setEnabled:YES];        
    [startButton setEnabled:YES];
    [pauseButton setEnabled:NO]; 
}

- (IBAction)loadGoalDNA:(id)sender {
}
@end
