//
//  Cell.h
//  DNA
//
//  Created by Tolya on 01.11.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject<NSCopying> {
    NSMutableArray *DNA;
}

@property NSUInteger length;

- (id)initWithLength:(NSUInteger)length;
- (id)initWithDNA:(NSMutableArray *)dna;

- (NSString *)stringValue;

+ (NSString *)randomChar;

- (void)createDNA;
- (int)hammingDistance:(Cell *)anotherCell;
- (Cell *)makeCrossingWithDNA:(Cell *)dna usingCrossKind:(int)crossKind;

@end
