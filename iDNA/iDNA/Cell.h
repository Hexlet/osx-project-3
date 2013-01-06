//
//  Cell.h
//  iDNA
//
//  Created by n on 25.12.12.
//  Copyright (c) 2012 witzawitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

-(int) hammingDistance: (Cell *) cell;
-(NSInteger) DNAsize;
-(NSString *) getDNAatIndex: (NSInteger)index;
-(void) setDNA: (NSString *) nucluotide atIndex: (NSInteger)index;
-(NSString *) randomNucleotide;
-(void) mutate: (int) percentToReplace;
-(void) initNucleotides;
-(id) initWithDNAlength: (NSInteger) length;
-(NSString *) DNAtoString;

@end
