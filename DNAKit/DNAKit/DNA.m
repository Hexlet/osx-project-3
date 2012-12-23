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
        chain = [[DNAChain alloc] initWithRandomElementsLength:length];
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

@end
