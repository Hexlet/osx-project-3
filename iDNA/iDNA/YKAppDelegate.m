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

        self.populationSize = 20;
        self.dnaLength = 30;
        self.mutationRate = 13;

        self.population = [NSMutableArray array];
    }

    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"dnaLength"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.isBusy = NO;
    
    // Generate new Goal DNA
    self.goalDNA = [[YKDNA alloc] initWithLength:self.dnaLength];
}

- (void)performEvolution
{
    
}

#pragma mark -
#pragma mark Delegate Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ((object == self) && keyPath) {
        if ([keyPath isEqualToString:@"dnaLength"]) {
            self.goalDNA = [[YKDNA alloc] initWithLength:self.dnaLength];
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
    self.window.title = @"iDNA in progress…";
    self.isBusy = YES;

    // Generate self.populationSize DNAs
    NSMutableArray *newPopulation = [NSMutableArray arrayWithCapacity:self.populationSize];
    for (NSUInteger i=0; i<self.populationSize; i++) {
        YKDNA *newDNA = [[YKDNA alloc] initWithLength:self.dnaLength];
        [newPopulation addObject:newDNA];
    }
    self.population = newPopulation;
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
