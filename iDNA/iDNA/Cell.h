//
//  Cell.h
//  iDNA
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property (readonly) int nucleotidesCount;
@property int maxSetSymbols;
@property NSMutableArray* DNA;
@property NSArray* nucleotides;

-(id)initWithLength:(int) l;

-(int) hammingDistance: (Cell*) theCell;
-(void) mutate: (int) x;


@end
