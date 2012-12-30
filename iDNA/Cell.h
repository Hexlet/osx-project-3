//
//  Cell.h
//  DNA
//
//  Created by D_Unknown on 11/6/12.
//  Copyright (c) 2012 D_Unknown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject
{
    NSMutableArray *DNA;
    NSArray  *nucleotidesArray;
    
}

-(id) initWithLength:(int)DNALength;
-(NSString*) getDNAString;
-(int) hammingDistance:(Cell*) c;
-(Cell*) crossbreedWith:(Cell*) partner;
-(NSString*) getNucleotide;

@end
