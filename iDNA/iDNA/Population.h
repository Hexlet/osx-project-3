//
//  Population.h
//  iDNA
//
//  Created by Anatoliy Dudarchuk on 25.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cell;

@interface Population : NSObject

- (id)initWithSize:(NSUInteger)size goalDNA:(Cell *)goalDNA;

- (NSArray *)items;

- (void)generateWithDNALength:(NSUInteger)dnaLength;
- (void)sort;
- (BOOL)isMatch;
- (void)makeCrossing;
- (void)mutateWithPercentOfMutation:(NSUInteger)percent;

@end
