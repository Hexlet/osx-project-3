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
#import "Population.h"

@interface MainWindowController () {
    NSThread *_evolutionThread;
}

- (void)generateDNA;
- (void)setEvolutionPaused:(BOOL)isPaused;
- (void)evolvePopulation:(id)state;

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
    self.generation = 0;
    self.bestMatch = 0;
    
    _evolutionThread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(evolvePopulation:)
                                                 object:nil];
    [_evolutionThread start];
}

- (void)evolvePopulation:(id)state
{
    Population *population = [[Population alloc] initWithSize:self.populationSize goalDNA:self.goalDNA];
    [population generateWithDNALength:self.dnaLength];

    while (![_evolutionThread isCancelled]) {
        self.generation++;
        
        [population sort];
        
        int hammingDistance = [[[population items] objectAtIndex:0] hammingDistance:self.goalDNA];
        NSUInteger count = [[population items] count];
        self.bestMatch = (count - hammingDistance) / (float)count * 100;
        
        if ([population isMatch]) {
            [self setEvolutionPaused:YES];
            _evolutionThread = nil;
            
            return;
        }
        
        [population makeCrossing];
        [population mutateWithPercentOfMutation:self.mutationRate];
    }
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
