//
//  Evolution.h
//  iDNA
//
//  Created by Александр Борунов on 13.12.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGeneration @"Generation"
#define kDistance @"Distance"
#define kPretender @"Pretender"

@class Cell;

@interface Evolution : NSObject {
    NSInteger dnaLength;
    NSInteger populationSize;
    NSInteger mutationRate;
    Cell     *goalCell;
    
    NSMutableArray *population;
    NSInteger generation;
//    NSMutableDictionary *generationResult;
    
}




+(NSString*)getRandomDNAWithLength:(NSInteger)dnalength;
+(BOOL)isValidDNAString:(NSString *)s;

-(id)initWithDNA:(NSInteger)dl PopulationSize: (NSInteger)pSize MutationRate:(NSInteger)mr ToGoal: (NSString*)goal;

-(NSDictionary *)stepEvolution;


-(void)sortPopulationByHammingDistance;

-(void)startEvolution;
-(void)pauseEvolution;
-(void)resumeEvolution;

@end
