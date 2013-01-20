//
//  DNAChain.m
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNAChain.h"


@implementation DNAChain

- (id)initWithLength:(NSUInteger)length {
    if (self = [super init]) {
        _elements = [DNAChain createInitialDNAChainElements:length];
        _length = length;
    }
    return self;
}

- (id)initWithElements:(DNAElement *)elements length:(NSUInteger)length
{
    if (self = [super init]) {
        _elements = elements;
        _length = length;
    }
    return self;
}

- (id)initWithRandomElementsLength:(NSUInteger)length
{
    DNAElement *elements = [DNAChain getRandomDNAChainArrayWithLength:length];
    self = [self initWithElements:elements length:length];
    return self;
}

- (void)dealloc
{
    free(_elements);
}

- (NSUInteger)hammingDitanceToDNAChain:(DNAChain *)chain
{
    if (_length != [chain length]) {
        @throw [NSException exceptionWithName:@"NonEqualLengthException" reason:@"Chains have non equal lengths!" userInfo:nil];
    }
    NSUInteger distance = 0;
    for (NSUInteger i = 0; i < _length; ++i) {
        if (_elements[i] != [chain elements][i]) {
            ++distance;
        }
    }
    return distance;
}

- (NSString *)description
{
    return [[NSString alloc] initWithUTF8String:_elements];
}

+ (DNAElement *)createInitialDNAChainElements:(NSUInteger)length
{
    DNAElement *elements = calloc(length, sizeof(DNAElement));
    memset(elements, DNA_CHAIN_ELEMENTS[0], length * sizeof(DNAElement));
    return elements;
}

+ (DNAElement *)getRandomDNAChainArrayWithLength:(NSUInteger)length
{    
    DNAElement *chainArray = calloc(length, sizeof(DNAElement));
    for (NSUInteger i = 0; i < length; ++i)
        chainArray[i] = [self getRandomElement];
    return chainArray;
}

+ (DNAElement)getRandomElement
{
    return DNA_CHAIN_ELEMENTS[arc4random() % DNA_CHAIN_ELEMENT_COUNT];
}

@end
