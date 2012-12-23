//
//  OneMiddlePointDNAChainCrossover.m
//  DNAKit
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import "DNAOneMiddlePointChainCrossover.h"

#import "DNAChain.h"


@implementation DNAOneMiddlePointChainCrossover

- (DNAChain *)crossoverDNAChain:(DNAChain *)chainA withDNAChain:(DNAChain *)chainB
{
    DNAChain* crossoverChain = [super crossoverDNAChain:chainA withDNAChain:chainB];
    if (crossoverChain) {
        NSUInteger middle = [crossoverChain length] / 2;
        for (NSUInteger i = 0; i < [crossoverChain length]; ++i) {
            if (i < middle) {
                [crossoverChain elements][i] = [chainA elements][i];
            } else {
                [crossoverChain elements][i] = [chainB elements][i];
            }
        }
    }
    return crossoverChain;
}

@end
