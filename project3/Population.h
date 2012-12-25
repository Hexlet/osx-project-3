//
//  Population.h
//  p3
//
//  Created by VITALIY NESTERENKO on 23.12.12.
//  Copyright (c) 2012 VITALIY NESTERENKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@interface Population : NSObject

    @property NSMutableArray * items;
    @property Cell * targetDNA;
    @property int dnaLength;


-(void) replaceWithTop50;
-(void) mutate:(int)percent;
-(BOOL) gotTarget;
- (void) create:(int)size;
-(id) init:(int)dna_size;
-(void) substituteFromTop50;
-(void) Sort;
-(void) print;
-(NSUInteger)nearestDistanceToTarget;
-(void)generateTarget;

@end
