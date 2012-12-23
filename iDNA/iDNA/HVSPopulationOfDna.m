//
//  HVSPopulationOfDna.m
//  iDNA
//
//  Created by VladIslav Khazov on 23.12.12.
//  Copyright (c) 2012 VladIslav Khazov. All rights reserved.
//

#import "HVSPopulationOfDna.h"

@implementation HVSPopulationOfDna

-(id)init {
    self = [super init];
    if (self) {
        [self setPopulationLengthDna:100];
        [self setPopulationRate:30];
        [self setPopulationSize:5000];
        
    }
    return self;
}

@end
