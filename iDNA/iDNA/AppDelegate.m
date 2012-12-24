//
//  AppDelegate.m
//  iDNA
//
//  Created by alex on 17/12/2012.
//  Copyright (c) 2012 alex. All rights reserved.
//

#import "AppDelegate.h"
#import "Cell.h"
#import "Population.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setValue:[NSNumber numberWithInt:1+arc4random()%100] forKey:@"populationSize"];
    [self setValue:[NSNumber numberWithInt:1+arc4random()%100] forKey:@"DNALength"];
    [self setValue:[NSNumber numberWithInt:0] forKey:@"mutationRate"];
}

-(id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDNAChange:) name:DNAChangeNotification object:nil];
        
        _DNA = [[Cell alloc] init];
        [self addObserver:self forKeyPath:@"DNALength" options:0 context:nil];
        
        paused = NO;
    }
    
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"DNALength"]) {
        [_DNA populateForSize:[[self valueForKey:@"DNALength"] intValue]];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)handleDNAChange:(NSNotification *)n
{
    [_goalDNATextField setStringValue:[_DNA asString]];
}

- (IBAction)startEvolution:(id)sender
{
    [self setStateOfUIElements:FALSE];

    [NSThread detachNewThreadSelector:@selector(evolutionJob) toTarget:self withObject:nil];
    
}

-(void)evolutionJob
{
    Population *population = [[Population alloc] initPopulationWithSize:[[self valueForKey:@"populationSize"] intValue] andSizeDNA:[[self valueForKey:@"DNALength"] intValue] andGoalDNA:_DNA];
    
    int i = 1;
    int evolutionResult = -1;
    int bestMatch = 999;
    int l = [[self valueForKey:@"DNALength"] intValue];
    paused = NO;

    while (true) {
        [_generationLabel setStringValue:[NSString stringWithFormat:@"Generation: %d", i]];
        
        evolutionResult = [population evolution:[[self valueForKey:@"mutationRate"] intValue]];
        if (bestMatch > evolutionResult) {
            bestMatch = evolutionResult;
            [_bestMatchLabel setStringValue:[NSString stringWithFormat:@"Best individual match - %d%%", 100-bestMatch*100/l]];
        }
        
        // для отладки
        /*
        [_goalDNATextField setStringValue:[[_DNA asString] stringByAppendingFormat:@"\r\n%@ - %d (%d)", [[population bestMatch] asString], [[population bestMatch] hammingDistance:_DNA], evolutionResult]];
        */
        
        if (paused || !bestMatch) {
            [self setStateOfUIElements:TRUE];
            break;
        }
        
        i++;
    }
}

- (IBAction)pauseClick:(id)sender
{
    paused = YES;
}

-(void)setStateOfUIElements:(BOOL)newState
{
    [_pauseButton setEnabled:!newState];
    [_startEvolutionButton setEnabled:newState];
    [_populationSizeSlider setEnabled:newState];
    [_populationSizeTextField setEnabled:newState];
    [_DNALengthSlider setEnabled:newState];
    [_DNALengthTextField setEnabled:newState];
    [_mutationRateSlider setEnabled:newState];
    [_mutationRateTextField setEnabled:newState];
}

@end
