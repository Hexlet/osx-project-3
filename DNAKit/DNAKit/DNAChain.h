//
//  DNAChain.h
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DNAChain : NSObject

typedef char DNAElement;

@property (readonly) DNAElement *elements;
@property (readonly) NSUInteger length;

- (id)initWithElements:(DNAElement *)elements length:(NSUInteger)length;
- (id)initWithRandomElementsLength:(NSUInteger)length;

@end
