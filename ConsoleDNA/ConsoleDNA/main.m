//
//  main.m
//  ConsoleDNA
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../../DNAKit/DNAKit/DNASet.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSUInteger length = 200;
        DNASet *dnas = [[DNASet alloc] initWithDNALength:length capacity:100];
        dnas.goalDNA = [[DNA alloc] initWithLength:length];
        dnas.mutatePercent = 5;
        
        for (NSUInteger i = 0; i < 1000; ++i) {
            [dnas evolve];
            NSLog(@"distance = %zul", [dnas minDistance]);
        }
    }
    return 0;
}

