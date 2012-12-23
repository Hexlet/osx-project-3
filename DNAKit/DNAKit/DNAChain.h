//
//  DNAChain.h
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNAChain : NSObject

@property (readonly) NSUInteger length;

+ (DNAChain *)randomDNAChainWithLength:(NSUInteger)length;

@end
