//
//  DNAChain.m
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNAChain.h"

@implementation DNAChain
{
    char *chainArray;
}

- (id)initWithDNAChainArray:(char *)array length:(NSUInteger)length
{
    if (self = [super init]) {
        chainArray = array;
        _length = length;
    }
    return self;
}

- (NSString *)description
{
    return [[NSString alloc] initWithUTF8String:chainArray];
}

+ (DNAChain *)randomDNAChainWithLength:(NSUInteger)length
{
    char *chainArray = [DNAChain getRandomDNAChainArrayWithLength:length];
    DNAChain *chain = [[DNAChain alloc] initWithDNAChainArray:chainArray length:length];
    return chain;
}

+ (char *)getRandomDNAChainArrayWithLength:(NSUInteger)length
{
    NSUInteger chainElementCount = strlen(CHAIN_ELEMENTS);
    
    char *chainArray = calloc(length, sizeof(char));
    for (NSUInteger i = 0; i < length; ++i)
        chainArray[i] = CHAIN_ELEMENTS[arc4random() % chainElementCount];
    return chainArray;
}

static char CHAIN_ELEMENTS[] = "ACGT";

@end
