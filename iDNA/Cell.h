//
//  Cell.h
//  Dna
//
//  Created by conference on 22.11.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject {
    NSMutableArray *dnaArray;
    NSArray *dnaBitsArray;
    BOOL maskArray[9999];
    NSInteger size;
}

-(int) hammingDistance:(Cell*)obj;
-(NSString*) getObj:(int)index;
-(void)mutate:(NSInteger)percents;
-(void)initialize:(NSInteger)newSize;
-(NSString*)getGoalDNA;
-(void) updateGoalDNA:(NSInteger) newSize;
-(void)reproduct:(Cell*)otherDNA;
-(void)print;
-(NSInteger)length;

@end
