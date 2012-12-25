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
    _isEvolutionOver = false;
    
    self.distanceToTarget = _dnaLength;
    
 
    [self addObserver:self forKeyPath:@"dnaLength" options:0 context:nil];
    [self addObserver:self forKeyPath:@"distanceToTarget" options:0 context:nil];
    self.generationCount = 0;
//    [self initPopulation];
    return self;
}

-(void) resetEvolution {
    self.isEvolutionOver = true;
    self.generationCount = 0;
     self.distanceToTarget = _dnaLength;
    
    

}

-(void) initPopulation {
    _population = [[Population alloc] init:_dnaLength];
    [_population generateTarget];
    [_population create:_populationSize];
}

-(void) generateGoalDNA {
    [self initPopulation];
    [_goalDNAField setStringValue:[_population.targetDNA asString]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self generateGoalDNA];
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
        self.population.dnaSize = _dnaLength;
        self.distanceToTarget = _dnaLength;
        [self generateGoalDNA];
    }

    
    if ([keyPath isEqual:@"distanceToTarget"]) {
        
        // При изменении self.minimumHammingDistance изменяем и self.bestIndividualMatch для правильного отображения индикатора выполнения в интерфейсе
        if (self.dnaLength > 0) {
            NSUInteger progress = 100-100*self.distanceToTarget/self.population.dnaSize;
            if (progress > self.distanceToTarget)
                self.distanceToTarget = progress;
        }

    }
    
}





-(void) EvStep {
    
    
        
        [_population Sort];
        [_population subFromTop50];
        [_population mutate:_mutationRate];
  
        int currentDistanceToTarget = [self.population nearestDistanceToTarget];
    
        if (currentDistanceToTarget < self.distanceToTarget) {
         self.distanceToTarget =[self.population nearestDistanceToTarget];
        }
    
    self.generationCount++;
  
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EvStepOver" object:self];
    
}

- (IBAction)startEvolution:(id)sender {

//       [_population create:_populationSize];
//    [_bestMatch setIntegerValue:_population.dnaSize];
    self.isEvolutionOver = false;
    [self performSelectorInBackground:@selector(EvStep) withObject:nil];
    
}

-(void)Evolution {
    if (!self.isEvolutionOver) {
         [self performSelectorInBackground:@selector(EvStep) withObject:nil];
    }
}
- (IBAction)pause:(id)sender {
    [self resetEvolution];
}

- (IBAction)loadDNA:(id)sender {
   
    NSLog(@"%i",self.distanceToTarget);
    self.generationCount++;

}
@end
