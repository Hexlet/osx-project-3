//
//  Cell.h
//  DNA
//
//  Created by Tolya on 01.11.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const DNAExceptionName;

@interface Cell : NSObject<NSCopying> {
    NSMutableArray *DNA;
}

@property NSUInteger length;

+ (id)DNAWithContentOfURL:(NSURL *)url;

- (id)initWithLength:(NSUInteger)length;
- (id)initWithDNA:(NSMutableArray *)dna;

- (NSString *)stringValue;

+ (NSString *)randomChar;

- (void)createDNA;
- (void)loadFromURL:(NSURL *)url;
- (int)hammingDistance:(Cell *)anotherCell;
- (Cell *)makeCrossingWithDNA:(Cell *)dna usingCrossKind:(int)crossKind;

@end
