//
//  DNAKit.m
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNA.h"

#import "DNAChain.h"

@implementation DNA
{
    DNAChain *chain;
}

- (id)initWithLength:(NSUInteger)length
{
    if (self = [super init]) {
        chain = [DNAChain randomDNAChainWithLength:length];
    }
    return self;
}

- (NSUInteger)length
{
    return [chain length];
}

- (NSString *)description
{
    return [chain description];
}

+ (DNA *)dnaWithLength:(NSUInteger)length
{
    DNA *dna = [DNA alloc];
    return [dna initWithLength:length];
}

@end
