//
//  DNAChainMutating.h
//  DNAKit
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DNAChain;


@protocol DNAChainCrossovering <NSObject>

- (DNAChain *)crossoverDNAChain:(DNAChain *)chainA withDNAChain:(DNAChain *)chainB;

@end
