#import "Evolution.h"
#import "Cell.h"

NSInteger compareCellsByHammingDistanceToTargetCell(Cell *cell1, Cell *cell2, void *context) {
    Cell *goalCell = (__bridge Cell *)(context);
    int hammingDistance1 = [goalCell hammingDistance:cell1];
    int hammingDistance2 = [goalCell hammingDistance:cell2];
    if (hammingDistance1 < hammingDistance2) {
        return (NSComparisonResult) NSOrderedAscending;
    } else if (hammingDistance1 > hammingDistance2) {
        return (NSComparisonResult) NSOrderedDescending;
    } else {
        return (NSComparisonResult) NSOrderedSame;
    }
}

@implementation Evolution

@synthesize populationSize, dnaLength, mutationRate, inProgress, paused, generation;

-(id)init {
    if (self = [super init]) {
        inProgress = NO;
        paused = NO;
        generation = 0;
    }
    return self;
}

-(void)start {
    inProgress = YES;
    paused = NO;
    generation = 0;
    [self generateGoalCell];
    [self generatePopulation];
    [self performSelectorInBackground:@selector(nextGeneration) withObject:nil];
}

-(void)nextGeneration {
    [self sortPopulation];
    NSInteger closestDistance = [[population objectAtIndex:0] hammingDistance:goalCell];
    NSLog(@"step: %li, closest: %li", generation, closestDistance);
    if (closestDistance == 0) {
        [self stop];
        return;
    }
    generation++;
    [self hybridizePopulation];
    [self mutatePopulation];
    if (paused == NO && inProgress == YES) {
        [self nextGeneration];
    }
}

-(void)mutatePopulation {
    for (Cell *cell in population) {
        [cell mutate:mutationRate];
    }
}

-(void)hybridizePopulation {
    int losersThreshold = (int)(populationSize * 0.5);
    for (int i = losersThreshold; i < populationSize; i++) {
        Cell *mother = [population objectAtIndex: arc4random_uniform(losersThreshold)];
        Cell *father = [population objectAtIndex: arc4random_uniform(losersThreshold)];
        Cell *child = [self hybridizeCell:mother withCell:father];
        [population replaceObjectAtIndex:i withObject:child];
    }
}

-(Cell *)hybridizeCell:(Cell *)cell1 withCell:(Cell *)cell2 {
    NSMutableArray *dna = [NSMutableArray arrayWithCapacity:dnaLength];
    int threshold = (int)(dnaLength * 0.5);
    for (int i = 0; i < dnaLength; i++) {
        Cell *cell = i < threshold ? cell1 : cell2;
        [dna addObject:[cell nucleobaseAtIndex:i]];
    }
    return [[Cell alloc] initWithDNA:dna];
}

-(void) generateGoalCell {
    goalCell = [[Cell alloc] initWithRandomDNAOfLength:dnaLength];
}

-(void) generatePopulation {
    population = [[NSMutableArray alloc] init];
    for (int i = 0; i < populationSize; i++) {
        [population addObject:[[Cell alloc] initWithRandomDNAOfLength:dnaLength]];
    }
}

-(void) sortPopulation {
    [population sortUsingFunction:compareCellsByHammingDistanceToTargetCell context:(__bridge void *)(goalCell)];
}

-(void)stop {
    inProgress = NO;
    paused = NO;
}

-(void)pause {
    paused = YES;
}

-(void)resume {
    paused = NO;
    [self performSelectorInBackground:@selector(nextGeneration) withObject:nil];
}

@end
