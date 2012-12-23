//
//  AppDelegate.m
//  105
//
//  Created by Stas on 12/15/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import "AppDelegate.h"
#import "Cell.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

Cell *myCell1;

- (IBAction)sliDnaLength:(id)sender {
    [Cell setDnaLength:[sender intValue]];
    myCell1 = [[Cell alloc] init];
    [monitor setStringValue:[myCell1 print]];
}

- (IBAction)tfDnaLength:(id)sender {
    [Cell setDnaLength:[sender intValue]];
    myCell1 = [[Cell alloc] init];
    [monitor setStringValue:[myCell1 print]];
}

- (IBAction)startEvolution:(id)sender {

    [sliPopSizeDisplay setEnabled:NO];
    [sliPopSizeDisplay displayIfNeeded];
    [sliDnaLengthDisplay setEnabled:NO];
    [sliDnaLengthDisplay displayIfNeeded];
    [sliMutationRateDisplay setEnabled:NO];
    [sliMutationRateDisplay displayIfNeeded];
    [startEvolutionDisplay setEnabled:NO];
    [startEvolutionDisplay displayIfNeeded];

    NSMutableArray *population = [[NSMutableArray alloc] initWithCapacity:popSize];
    NSMutableArray *sortPopulation = [[NSMutableArray alloc] initWithCapacity:popSize];

    // процесс заполнения популяции
    for (int popCount = 0; popCount < popSize; popCount++)
        [population addObject:[[Cell alloc] init]];
    
    NSLog(@"Generation 0:");
    for (int popCount = 0; popCount < popSize; popCount++)
        NSLog(@"index: %i, DNA: %@, HD: %i", popCount, [[population objectAtIndex:popCount] print], [myCell1 hammingDistance:[population objectAtIndex:popCount]]);
    NSLog(@" ");
    
    int countOfGeneration = 1;
    int count;                                  // переменная для циклов for в цикле do while (чтобы каждый раз не инициализировать в телах цикла for)
    
    Cell *child;

    while (YES) {
        // процесс сортировки
        for (int dnaCount = 0; dnaCount <= dnaLength; dnaCount++) 
            for (count = 0; count < popSize; count++)
                if ([myCell1 hammingDistance:[population objectAtIndex:count]] == dnaCount)
                    [sortPopulation addObject:[population objectAtIndex:count]];
        
        [status setIntValue:countOfGeneration];
        [status displayIfNeeded];
        
        NSLog(@"After sorting");
        NSLog(@"Generation %i:", countOfGeneration);
        for (int popCount = 0; popCount < popSize; popCount++)
            NSLog(@"index: %i, DNA: %@, HD: %i", popCount, [[sortPopulation objectAtIndex:popCount] print], [myCell1 hammingDistance:[sortPopulation objectAtIndex:popCount]]);
        NSLog(@" ");
        
        // проверка: создана ли особь, совпадающая с Goal DNA
        if ([myCell1 hammingDistance:[sortPopulation objectAtIndex:0]] == 0) {
            NSLog(@"Найден элемент, совпадающий с Goal DNA, в поколении %i", countOfGeneration);
            NSLog(@"Это элемент %@", [[sortPopulation objectAtIndex:0] print]);
            break;
        }

        // процесс скрещивания
        for (count = (popSize + 1) / 2; count < popSize; count++) {
            int indexOfPap = arc4random() % popSize / 2;
            int indexOfMom = arc4random() % popSize / 2;
            child = [[sortPopulation objectAtIndex:indexOfPap] sex:[sortPopulation objectAtIndex:indexOfMom]];
            [sortPopulation replaceObjectAtIndex: count withObject:child];
        }

        NSLog(@"After sex");
        NSLog(@"Generation %i:", countOfGeneration);
        for (int popCount = 0; popCount < popSize; popCount++)
            NSLog(@"index: %i, DNA: %@, HD: %i", popCount, [[sortPopulation objectAtIndex:popCount] print], [myCell1 hammingDistance:[sortPopulation objectAtIndex:popCount]]);
        NSLog(@" ");
        
        // процесс мутации
        for (count = 0; count < popSize; count++) 
            [[sortPopulation objectAtIndex:count] mutate:mutRate];
        
        NSLog(@"After mutation");
        NSLog(@"Generation %i:", countOfGeneration);
        for (int popCount = 0; popCount < popSize; popCount++)
            NSLog(@"index: %i, DNA: %@, HD: %i", popCount, [[sortPopulation objectAtIndex:popCount] print], [myCell1 hammingDistance:[sortPopulation objectAtIndex:popCount]]);
        NSLog(@" ");
        
        [population removeAllObjects];
        [population addObjectsFromArray:sortPopulation];
        [sortPopulation removeAllObjects];

        countOfGeneration++;
    }

    [sliPopSizeDisplay setEnabled:YES];
    [sliDnaLengthDisplay setEnabled:YES];
    [sliMutationRateDisplay setEnabled:YES];
    [startEvolutionDisplay setEnabled:YES];
}

@end
