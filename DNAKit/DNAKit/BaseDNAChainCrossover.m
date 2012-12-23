//
//  BaseDNAChainCrossover.m
//  DNAKit
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "BaseDNAChainCrossover.h"

#import "DNAChain.h"


@implementation BaseDNAChainCrossover

- (DNAChain *)crossoverDNAChain:(DNAChain *)chainA withDNAChain:(DNAChain *)chainB
{
    if ([chainA length] != [chainB length]) {
        @throw [NSException exceptionWithName:@"NonEqualLengthException" reason:@"Chains have non equal lengths!" userInfo:nil];
    }
    return [[DNAChain alloc] initWithRandomElementsLength:[chainA length]];
}

@end
