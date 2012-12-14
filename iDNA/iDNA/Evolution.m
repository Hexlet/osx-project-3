//
//  Evolution.m
//  iDNA
//
//  Created by Александр Борунов on 13.12.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//

#import "Evolution.h"
#import "Cell.h"


@implementation Evolution

+(NSString*)getRandomDNAWithLength:(NSInteger)dl{
    NSMutableString *chain = [NSMutableString stringWithCapacity:dl];
    while (dl-- > 0){
        [chain appendString:@"A"];
    }
    return chain;
}

+(BOOL)isValidDNAString:(NSString *)s{
    BOOL isValid = YES;
    NSCharacterSet *alphabet = [NSCharacterSet characterSetWithCharactersInString: @"ACGT"];
    
    for (NSInteger i=0; i < [s length]; i++){
        if ( ![alphabet characterIsMember:[s characterAtIndex:i]] ){
            isValid = NO;
            break;
        }
    }
    return isValid;
}

-(id)init { // без параметров ничего не будет
    return nil;
}

-(id) initWithDNA:(NSInteger)dl PopulationSize:(NSInteger)pSize MutationRate:(NSInteger)mr ToGoal:(NSString *)goal {
    if ( self = [super init] ){
        dnaLength = dl;
        populationSize = pSize;
        mutationRate = mr;
        goalCell = [[Cell alloc]initFromString:goal];
        
        population = [NSMutableArray array]; // пустой создали
        generation = 0;
        
        // теперь создадим популяцию
        for (NSInteger i=0; i<populationSize; i++){
            Cell *c = [[Cell alloc] initWithDNAlength:dnaLength];
            [population addObject:c];
        }
        
        // отсортируем популяцию по близости к целевой ДНК
        [self sortPopulationByHammingDistance];
        

    }
    return self;
}


-(void)sortPopulationByHammingDistance {
    NSString *key = @"distance";
    NSString *cell = @"cell";
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (Cell *currentCell in population){
        NSDictionary *dict;
        NSInteger distance = [goalCell hammingDistance:currentCell];
        NSString *stringedDistance = [NSString stringWithFormat:@"%04ld",distance];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                stringedDistance, key, currentCell, cell, nil];
        [tempArray addObject:dict];
    }
    
    
    NSSortDescriptor *descriptor1 = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObjects:descriptor1, nil];
    [tempArray sortUsingDescriptors:descriptors];
    
    NSMutableArray *sortedPopulation = [NSMutableArray array];
    for (id i in tempArray){
        [sortedPopulation addObject:[i objectForKey:cell]];
    }
    population = sortedPopulation;
}


-(NSDictionary *)stepEvolution{
    // отбросим худшую половину
    NSRange badGuys; badGuys.location = populationSize/2; badGuys.length = populationSize - badGuys.location;
    [population removeObjectsInRange:badGuys];
    
    // теперь родим вместо убитых
    for (NSInteger i=badGuys.location; i<populationSize; i++){
        Cell *father = [population objectAtIndex:(arc4random()%badGuys.location)];
        Cell *mother = [population objectAtIndex:(arc4random()%badGuys.location)]; // да-да не вижу проблемы когда папа и мама одинаковые
        Cell *child = [[Cell alloc] initFromSex:father With:mother];
        [population addObject:child];
    }
    
    // теперь всех замутируем
    for (Cell *c in population) {
        [c mutate:(int)mutationRate];
    }
    // и отсортируем
    [self sortPopulationByHammingDistance];
    // и запишем что получилось
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    [result setObject:[NSString stringWithFormat:@"%04ld",++generation] forKey:kGeneration];

    Cell *first = [population objectAtIndex:0];
    NSInteger distance = [goalCell hammingDistance:first];
    NSString *stringedDistance = [NSString stringWithFormat:@"%04ld",distance];
    [result setObject:stringedDistance forKey:kDistance];
    
    [result setObject:[first printToString] forKey:kPretender];
    return result;
}



-(void)startEvolution{
    
}
-(void)pauseEvolution{
    
}
-(void)resumeEvolution{
    
}

         

@end
