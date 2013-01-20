//
//  DNAKit.h
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNA : NSObject

@property (readonly) NSUInteger length;

- (id)initWithLength:(NSUInteger)length;

- (NSUInteger)distanceToDNA:(DNA *)dna;

- (void)mutate:(NSUInteger)percent;

+ (DNA *)crossoverDNA:(DNA *)dnaA withDNA:(DNA *)dnaB;

@end
