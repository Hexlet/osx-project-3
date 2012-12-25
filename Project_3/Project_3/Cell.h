//
//  Cell.h
//  Gurin_DNA
//
//  Created by Admin on 11/7/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Cell : NSObject
{
    @public
    NSMutableArray *dna;
}

-(int)hammingDistance:(Cell*)second_dna;
-(void)createDnaElements:(int)size;
-(Cell*)cross:(Cell*)second_dna;

@end
