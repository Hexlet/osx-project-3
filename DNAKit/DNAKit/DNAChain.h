//
//  DNAChain.h
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef char DNAElement;

static DNAElement DNA_CHAIN_ELEMENTS[] = "ACGT";
static NSUInteger DNA_CHAIN_ELEMENT_COUNT = 4;


@interface DNAChain : NSObject

@property (readonly) DNAElement *elements;
@property (readonly) NSUInteger length;

- (id)initWithLength:(NSUInteger)length;
- (id)initWithElements:(DNAElement *)elements length:(NSUInteger)length;
- (id)initWithRandomElementsLength:(NSUInteger)length;

- (NSUInteger)hammingDitanceToDNAChain:(DNAChain *)chain;

@end
