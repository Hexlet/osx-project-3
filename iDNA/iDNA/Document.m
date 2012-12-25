//
//  Document.m
//  iDNA
//
//  Created by Vadim Iskuchekov on 23.12.12.
//  Copyright (c) 2012 Llama on the Boat. All rights reserved.
//

#import "Document.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    // присвоение начальных значений

    [_popSize setIntegerValue:[_popSizeSlider integerValue]];
    [_dnaLenght setIntegerValue:[_dnaLenghtSlider integerValue]];
    [_mutationRate setIntegerValue:[_mutationRateSlider integerValue]];
    
    // геренация целевой ДНК
    goalDNA = [[Cell alloc] initWithLength:(int)[_dnaLenght integerValue]];
    [_goalDna setStringValue:[goalDNA print]];
    
    // если длинна ДНК изменится
    [[self dnaLenght] setDelegate:self];
    
    // создаем массив под будущую популяцию
    population = [[NSMutableArray alloc]init];
    hammingDistatceForPopulation = [[NSMutableArray alloc]init];
    
    // кнопка Пауза не нажата
    pause = NO; 
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

- (void)controlTextDidChange:(NSNotification *)obj {
    if ([obj object] == [self dnaLenght]) {
        NSLog(@"Генерирую новую целевую ДНК...");
        [goalDNA generationDna:(int)[_dnaLenght integerValue]];
        [_goalDna setStringValue:[goalDNA print]];
    }
}

- (void)createPopulationWithSize:(int)size andLenght:(int)lenght {
    [population removeAllObjects];
    for (int i = 0; i < size; i++) {
        Cell *dna = [[Cell alloc]initWithLength:lenght];
        [population addObject:dna];
        [hammingDistatceForPopulation addObject:[dna hammingDistance:goalDNA]];
        //NSLog(@"hd: %@", [dna hammingDistance:goalDNA]);
    }
    NSLog(@"Population Count: %d", (int)[population count]);
}

- (IBAction)startEvolution:(id)sender {
    // создаю случайную популяцию
    [self createPopulationWithSize:(int)[_popSize integerValue] andLenght:(int)[_dnaLenght integerValue]];
    
    // делаем нактивными элементы интерфейса
    [[self popSize]setEditable:NO];
    [[self dnaLenght]setEditable:NO];
    [[self mutationRate]setEditable:NO];
    [[self startEvolutionButton]setEnabled:NO];
    [[self loadGoalDnaButton]setEnabled:NO];
    [[self popSizeSlider]setEnabled:NO];
    [[self dnaLenghtSlider]setEnabled:NO];
    [[self mutationRateSlider]setEnabled:NO];
    
    [[self pauseButton]setEnabled:YES];
    
    // начинаю эволюцию
    pause = NO; 
    [self evolution];
    
}

- (void)evolution {
    int generation = -1; // поколение
    NSNumber *bestMatch = [[NSNumber alloc]initWithInt:0]; // лучший показатель
    while (!pause) {
        // сортирую популяцию по hamming distance
        [self sortPopulation];
        
        generation++;
        NSLog(@"generation: %d", generation);
        NSLog(@"best match: %@", bestMatch);
        [_generation setIntegerValue:generation]; 
        bestMatch = [goalDNA hammingDistance:[population objectAtIndex:0]];        
        
        [_bestIndividualMatch setStringValue:[NSString stringWithFormat:@"%@ %%", bestMatch]];
        
        [_bestMatchProgress startAnimation:self];
        [_bestMatchProgress setDoubleValue:bestMatch.doubleValue];
        [_bestMatchProgress stopAnimation:self]; 
        
        if (bestMatch == 0) {
            pause = YES; 
        }
        
        // скрещиваем первую половину популяции со второй и заменяем получившимися потомками вторую половину
        NSLog(@"b cross: %@", bestMatch);
        [self crossing];
        NSLog(@"a cross: %@", bestMatch);
        
        // мутируем получившуюся популяцию
        for (Cell *curCell in population) {
            [curCell mutate:[_mutationRate intValue]];
        }
    }
}

- (void)crossing {
    // делим популяцию на 2 половины (если нечентая одного отбрасываем)
    int firstHalf = ([population count] / 2);
    
    NSArray *typeOfCrossing = [[NSArray alloc]initWithObjects:@"1", @"2", @"3", nil]; // 3 типа скрещивания
    
//    NSLog(@"0 dna: %@", [[population objectAtIndex:0]print]);
//    NSLog(@"1 dna: %@", [[population objectAtIndex:1]print]);
//    [[population objectAtIndex:0]crossWithCell:[population objectAtIndex:1] byTypeOfCross:@"2"];
//    NSLog(@"0 dna: %@", [[population objectAtIndex:0]print]);
//    NSLog(@"1 dna: %@", [[population objectAtIndex:1]print]);
    
    for (int i = 0; i < firstHalf; i++) {
        //NSLog(@"b: %@",[[population objectAtIndex:i] print]);
        [[population objectAtIndex:i]crossWithCell:[population objectAtIndex:(firstHalf + i)] byTypeOfCross:[typeOfCrossing objectAtIndex:arc4random()%3]];
        //NSLog(@"a: %@",[[population objectAtIndex:i] print]);
    }
}

- (void)sortPopulation {
    NSString *key = @"distance";
    NSString *cell = @"cell";
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (Cell *currentCell in population){
        
        NSDictionary *dict;
        NSNumber *distance = [[NSNumber alloc]initWithInteger:[goalDNA hammingDistance:currentCell].intValue];
        NSString *stringedDistance = [NSString stringWithFormat:@"%4@",distance];        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:stringedDistance, key, currentCell, cell, nil];
        [tempArray addObject:dict];
    }
    
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
        NSArray *descriptors = [NSArray arrayWithObjects:descriptor, nil];
        
        [tempArray sortUsingDescriptors:descriptors];      
        NSMutableArray *sortedPopulation = [NSMutableArray array];        
        for (id i in tempArray){            
            [sortedPopulation addObject:[i objectForKey:cell]];
        }        
        population = sortedPopulation;
}

- (IBAction)pause:(id)sender {
    pause = YES;
    
    // делаем нактивными элементы интерфейса
    [[self popSize]setEditable:YES];
    [[self dnaLenght]setEditable:YES];
    [[self mutationRate]setEditable:YES];
    [[self startEvolutionButton]setEnabled:YES];
    [[self loadGoalDnaButton]setEnabled:YES];
    [[self popSizeSlider]setEnabled:YES];
    [[self dnaLenghtSlider]setEnabled:YES];
    [[self mutationRateSlider]setEnabled:YES];
    
    [[self pauseButton]setEnabled:NO];

}

- (IBAction)loadGoalDna:(id)sender {
}

@end
