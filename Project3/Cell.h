//
//  Cell.h
//  Project3
//
//  Created by Bogdan Pankiv on 12/24/12.
//  Copyright (c) 2012 Bogdan Pankiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject {
    NSMutableArray *dna;
    int dnaLength;
}

-(id) init;
-(id) initWithDnaLength: (int)x;
-(id) initWithCell: (Cell*)cell;
-(int) hammingDistance: (Cell*)cell;
-(NSNumber *) getDnaAtPosition: (int)pos;
-(NSString *) print;

@end
