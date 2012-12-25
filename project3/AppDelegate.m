//
//  AppDelegate.m
//  project3
//
//  Created by VITALIY NESTERENKO on 24.12.12.
//  Copyright (c) 2012 VITALIY NESTERENKO. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

-(id) init {
    self = [super init];
    
    _populationSize = 20;
    _dnaLength = 100;
    _mutationRate = 30;
    _isEvolutionOver = true;
    
    self.distanceToTarget = _dnaLength;
    self.generationCount = 0;
    self.progress = 0;
    
 
    [self addObserver:self forKeyPath:@"dnaLength" options:0 context:nil];
    [self addObserver:self forKeyPath:@"distanceToTarget" options:0 context:nil];

    return self;
}



-(void) initPopulation {
    _population = [[Population alloc] init: _dnaLength];
    [_population generateTarget];
    [_population create:_populationSize];
    self.goalDNA = [_population.targetDNA asString];
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self initPopulation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(evStepOver:) name:@"EvStepOver" object:nil];
}


- (void)evStepOver:(NSNotification *)aNotification
{
    if (aNotification && [[aNotification name] isEqualToString:@"EvStepOver"]) {
        [self Evolution];
    }
}



- (void)observeValueForKeyPath:(NSString *)keyPath
                        ofObject:(id)object
                        change:(NSDictionary *)change
                        context:(void *)context {

    if ([keyPath isEqual:@"dnaLength"]) {
        self.population.dnaLength = _dnaLength;
        self.distanceToTarget = _dnaLength;
        [self initPopulation];
        self.goalDNA = [_population.targetDNA asString];
    }

    
     else if ([keyPath isEqual:@"distanceToTarget"]) {
        
           if (self.dnaLength > 0) {
            NSUInteger currentProgress = 100-100*self.distanceToTarget/_dnaLength;
            if (currentProgress > self.progress)
                self.progress = currentProgress;
        }

    }
    
}





-(void) resetEvolution {
    self.isEvolutionOver = true;
    self.generationCount = 0;
    self.progress = 0;
    self.distanceToTarget = _dnaLength;
    self.window.title = @"iDNA";
}

-(void)Evolution {
    if (!self.isEvolutionOver) {
        [self performSelectorInBackground:@selector(EvStep) withObject:nil];
    }
}

-(void) EvStep {
        
    [self SortPopulation];
    [self substituteHalfPopulationWithTop50];
    [self mutatePopulation];
  
    NSUInteger currentDistanceToTarget = [self nearestDistanceToTarget];
    
        if (currentDistanceToTarget < self.distanceToTarget) {
            self.distanceToTarget = currentDistanceToTarget;
        }
    
    self.generationCount++;
  
    if(_population.gotTarget) {
        _isEvolutionOver = true;
        return;
    }
    
    [[NSNotificationCenter  defaultCenter] postNotificationName:@"EvStepOver" object:self];
    
}

- (IBAction)startEvolution:(id)sender {
    self.isEvolutionOver = false;
    self.window.title = @"iDNA in progress…";
    [self performSelectorInBackground:@selector(EvStep) withObject:nil];
   
}


- (IBAction)pause:(id)sender {
    [self resetEvolution];
}

- (IBAction)loadDNA:(id)sender {

}



- (void)SortPopulation {
    [_population Sort];
}

- (void)substituteHalfPopulationWithTop50 {
    [_population substituteFromTop50];
}

- (void)mutatePopulation {
    [_population mutate:_mutationRate];
}

- (NSUInteger)nearestDistanceToTarget {
    return [self.population nearestDistanceToTarget];
}

@end
