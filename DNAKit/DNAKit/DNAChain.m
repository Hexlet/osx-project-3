//
//  DNAChain.m
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNAChain.h"

@implementation DNAChain

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

- (NSString *)description
{
    return [[NSString alloc] initWithUTF8String:_elements];
}

#pragma mark -

+ (DNAElement *)getRandomDNAChainArrayWithLength:(NSUInteger)length
{
    NSUInteger chainElementCount = strlen(CHAIN_ELEMENTS);
    
    char *chainArray = calloc(length, sizeof(DNAElement));
    for (NSUInteger i = 0; i < length; ++i)
        chainArray[i] = CHAIN_ELEMENTS[arc4random() % chainElementCount];
    return chainArray;
}

static DNAElement CHAIN_ELEMENTS[] = "ACGT";

@end
