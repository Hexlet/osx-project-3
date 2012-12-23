//
//  main.m
//  ConsoleDNA
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "../../DNAKit/DNAKit/DNA.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        DNA *dna = [DNA dnaWithLength:15UL];
        NSLog(@"%@", dna);
    }
    return 0;
}

