//
//  DNASet.h
//  DNAKit
//
//  Created by Dmitry Davidov on 23.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DNA.h"

@interface DNASet : NSObject

@property (readonly) NSUInteger minDistance;

@property NSUInteger mutatePercent;
@property DNA *goalDNA;

- (id)initWithDNALength:(NSUInteger)length capacity:(NSUInteger)capacity;

- (void)evolve;

@end
