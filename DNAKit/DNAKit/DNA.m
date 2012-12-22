//
//  DNAKit.m
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNA.h"

@implementation DNA
{
    char *chain;
}

+ (DNA *)dnaWithLength:(NSUInteger)length
{
    DNA *dna = [DNA alloc];
    return [dna initWithLength:length];
}

- (id)initWithLength:(NSUInteger)length
{
    if (self = [super init]) {
        chain = calloc(length, sizeof(char));
        for (uint i = 0; i < length; ++i)
            chain[i] = 'A';
    }
    return self;
}

- (NSString *)description
{
    return [[NSString alloc] initWithUTF8String:chain];
}

@end
