//
//  MainWindowController.m
//  iDNA
//
//  Created by Tolya on 25.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "MainWindowController.h"
#import "Cell.h"
#import "Cell+mutator.h"

@interface MainWindowController () {
    NSThread *_evolutionThread;
}

- (void)generateDNA;
- (void)setEvolutionPaused:(BOOL)isPaused;
- (NSMutableArray *)generatePopulation;
- (void)startEvolutionOnPopulation:(NSArray *)population;
- (NSArray *)sortPopulation:(NSArray *)population;
- (void)makeCrossingInPopulation:(NSMutableArray *)population;
- (void)mutatePopulation:(NSMutableArray *)population;

@end

@implementation MainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _populationSize = 3400;
        _dnaLength = 42;
        _mutationRate = 13;
        _goalDNA = [[Cell alloc] initWithLength:_dnaLength];
        [_goalDNA createDNA];
        _isEvolutionPaused = YES;
        _evolutionThread = nil;
        _generation = 0;
        
        [self addObserver:self forKeyPath:@"dnaLength" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)generateDNA
{
    [self willChangeValueForKey:@"goalDNA"];
    self.goalDNA.length = self.dnaLength;
    [self.goalDNA createDNA];
    [self didChangeValueForKey:@"goalDNA"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"dnaLength"]) {
        [self generateDNA];
    }
}

- (void)setEvolutionPaused:(BOOL)isPaused
{
    [self willChangeValueForKey:@"isEvolutionPaused"];
    _isEvolutionPaused = isPaused;
    [self didChangeValueForKey:@"isEvolutionPaused"];
}

- (IBAction)loadGoalDNA:(id)sender
{
    [self generateDNA];
}

- (IBAction)startEvolution:(id)sender
{
    [self setEvolutionPaused:NO];
    
    NSMutableArray *population = [self generatePopulation];
    _evolutionThread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(startEvolutionOnPopulation:)
                                                 object:population];
    [_evolutionThread start];
}

- (void)startEvolutionOnPopulation:(NSArray *)population
{
    while (![_evolutionThread isCancelled]) {
        self.generation++;
        
        NSMutableArray *sortedPopulation = [[NSMutableArray alloc] initWithArray: [self sortPopulation:population]];
        
        self.bestMatch = [[sortedPopulation objectAtIndex:0] hammingDistance:self.goalDNA];
        
        for (Cell *dna in sortedPopulation) {
            if ([dna hammingDistance:self.goalDNA] == 0) {
                [self setEvolutionPaused:YES];
                _evolutionThread = nil;
                
                return;
            }
        }
        
        [self makeCrossingInPopulation:sortedPopulation];
        [self mutatePopulation:sortedPopulation];
    }
}

- (NSArray *)sortPopulation:(NSArray *)population
{
    NSComparator dnaSortBlock = ^(Cell *cell1, Cell *cell2) {
        int d1 = [cell1 hammingDistance:self.goalDNA];
        int d2 = [cell2 hammingDistance:self.goalDNA];
        
        if (d1 == d2)
            return NSOrderedSame;
        return d1 > d2 ? NSOrderedAscending : NSOrderedDescending;
    };
    return [population sortedArrayUsingComparator:dnaSortBlock];
}

- (void)makeCrossingInPopulation:(NSMutableArray *)population
{
    if ([population count] < 2)
        return;
    
    int maxIndex = [population count] / 2 - 1;
    int index1 = arc4random_uniform(maxIndex);
    int index2 = arc4random_uniform(maxIndex);
    Cell *dna1 = [population objectAtIndex:index1];
    Cell *dna2 = [population objectAtIndex:index2];
    int crossKind = arc4random_uniform(2);
    Cell *newDna = [dna1 makeCrossingWithDNA:dna2 usingCrossKind:crossKind];
    
    for (NSUInteger i = maxIndex + 1; i < [population count]; i++) {
        [population replaceObjectAtIndex:i withObject:[newDna copy]];
    }
}

- (void)mutatePopulation:(NSMutableArray *)population
{
    for (Cell *dna in population) {
        [dna mutate:self.mutationRate];
    }
}

- (NSMutableArray *)generatePopulation
{
    NSMutableArray *population = [[NSMutableArray alloc] initWithCapacity:self.populationSize];
    for (NSInteger i = 0; i < self.populationSize; i++) {
        Cell *dna = [[Cell alloc] initWithLength:self.dnaLength];
        [dna createDNA];
        
        [population addObject:dna];
    }
    
    return population;
}

- (IBAction)pauseEvolution:(id)sender
{
    if (_evolutionThread) {
        [_evolutionThread cancel];
        while (!_evolutionThread.isFinished)
            usleep(200);
        _evolutionThread = nil;
    }

    [self setEvolutionPaused:YES];
}
@end
