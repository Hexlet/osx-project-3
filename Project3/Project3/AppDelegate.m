//
//  AppDelegate.m
//  Project3
//
//  Created by Bogdan Pankiv on 12/24/12.
//  Copyright (c) 2012 Bogdan Pankiv. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_GoalDnaInput setStringValue:[goaldna print]];
}

-(id)init {
    if (self = [super init]) {
        [self setValue:[NSNumber numberWithInt:230] forKey:@"populationSize"];
        [self setValue:[NSNumber numberWithInt:42] forKey:@"dnaLength"];
        [self setValue:[NSNumber numberWithInt:10] forKey:@"mutationRate"];
        
        goaldna = [[Cell alloc]initWithDnaLength:(int)dnaLength];
        
        [self setValue:[NSNumber numberWithInt:0] forKey:@"pause"];
        generation = 0;
    }
    return self;
}


-(void)setPopulationSize: (int) x {
    if (x>1000000) return; // BUG

    if (x>10000) x = 10000;
    if (x<0) x = 0;

    [_PopulationSizeInput setStringValue:[NSString stringWithFormat:@"%d", x]];
    
    populationSize = x;
}

-(NSInteger)populationSize {
    return populationSize;
}

-(void)setDnaLength: (int) x {
    if (x>1000000) return; // BUG
    
    if (x<0) x = 0;
    if (x>100) x = 100;

    [_DnaLengthInput setStringValue:[NSString stringWithFormat:@"%d", x]];
    dnaLength = x;
    goaldna = [[Cell alloc]initWithDnaLength:x];
    [_GoalDnaInput setStringValue:[goaldna print]];
}

-(NSInteger)dnaLength {
    return dnaLength;
}

-(void)setMutationRate: (int) x {
    if (x > 1000000) return; // BUG
    
    if (x>100) x = 100;
    if (x<0) x = 0;
    
    [_MutationRateInput setStringValue:[NSString stringWithFormat:@"%d", x]];
    mutationRate = x;
}

-(NSInteger)mutationRate {
    return mutationRate;
}

- (IBAction)StartEvolution:(id)sender {
    [self willChangeValueForKey:@"pause"];
    [self setValue:[NSNumber numberWithInt:1] forKey:@"pause"];
    [self didChangeValueForKey:@"pause"];
    
    population = [[NSMutableArray alloc]init];
    for (int i=0; i<populationSize; ++i) {
        [population addObject: [[Cell alloc]initWithDnaLength:(int)dnaLength]];
    }
    generation = 0;
    
/*    while (pause != 0) {*/
//    for (int k=0; k<10; ++k) {
//        [self process];
//    }
    [self performSelectorInBackground:@selector(process) withObject:nil];
}

- (IBAction)PauseEvolution:(id)sender {
    [self willChangeValueForKey:@"pause"];
    [self setValue:[NSNumber numberWithInt:0] forKey:@"pause"];
    [self didChangeValueForKey:@"pause"];
}

- (IBAction)LoadDNA:(id)sender {
}

-(void)process {
    while (pause != 0) {
        [_GenerationLabel setStringValue:[NSString stringWithFormat:@"Generation: %ld", generation]];
    
        [self sortPopulation];
        [self crossPopulation];
        [self mutatePopulation];
    
        [_BestMatchLabel setStringValue:[NSString stringWithFormat:@"Best individual match - %d%%",
                                         (int)(100 - [population[0] hammingDistance:goaldna] * 100 / dnaLength)]];
    
        if ([population[0] hammingDistance:goaldna] == 0) {
            [self willChangeValueForKey:@"pause"];
            [self setValue:[NSNumber numberWithInt:0] forKey:@"pause"];
            [self didChangeValueForKey:@"pause"];
        }
    
        generation++;
    }
}

-(void)crossPopulation {
    int first = random() % populationSize/2;
    int second = random() % populationSize/2;
    while (first == second) second = random() % populationSize/2;

    Cell *cell = [[Cell alloc]initWithCell:population[first]];
    [cell cross:population[second]];
    
    for (int i=populationSize/2+1; i<populationSize; ++i)
        population[i] = cell;
}

-(void)mutatePopulation {
    for (int i=0; i<populationSize; ++i)
        [population[i] mutate:(int)mutationRate];
}

-(void)sortPopulation {
    for (int i=0; i<populationSize; ++i) {
        for (int j=i+1; j<populationSize; ++j) {
            if ([population[i] hammingDistance:goaldna] > [population[j] hammingDistance:goaldna]) {
                Cell *tmp = population[i];
                population[i] = population[j];
                population[j] = tmp;
            }
        }
    }
}
@end
