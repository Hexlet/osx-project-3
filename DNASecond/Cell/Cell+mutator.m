//
//  Cell+mutator.m
//  NDA
//
//  Created by Tsyganov Stanislav on 12.11.12.
//  Copyright (c) 2012 Tsyganov Stanislav. All rights reserved.
//

#import "Cell+mutator.h"

@implementation Cell (mutator)
-(void)mutate:(NSInteger)percents{
    //    NSLog(@"DNA was: %@", self);
    //calculate num of genes
    NSInteger lengthOfDNA = [self.DNA count];
    
    int numOfGen = lengthOfDNA * percents / 100;
    
    //generate set with numbers to mutate
    //fill set until "percents" elements in it
    NSMutableArray* mutNumbers = [[NSMutableArray alloc] init];
    
    
    NSMutableArray* startArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < lengthOfDNA; i++) {
        [startArr addObject:[NSNumber numberWithInt:i]];
    }
    
    NSArray *dnaSymbols = [NSArray arrayWithObjects:@"A", @"T", @"G", @"C", nil];
    int dnaSymCount = (int)[dnaSymbols count];
    
    for (int i = 0; i < numOfGen; i++) {
        NSInteger lengthOfStart = [startArr count];
        
        NSInteger randNumInStartArray = arc4random_uniform(lengthOfStart);
        NSInteger numOfMutGen = [[startArr objectAtIndex:randNumInStartArray] integerValue];
        [startArr removeObjectAtIndex:randNumInStartArray];
        
        NSInteger numOfOldSymInDNAArray = [dnaSymbols indexOfObject:[self.DNA objectAtIndex:numOfMutGen]];
        
        //It's ok. There is no time to explain.
        NSString* newSym = [dnaSymbols objectAtIndex: (arc4random_uniform(dnaSymCount - 1) + 1 + numOfOldSymInDNAArray) % dnaSymCount];
        
        [self.DNA setObject:newSym atIndexedSubscript:numOfMutGen];
    }
    
    //    NSLog(@"DNA now: %@", self);
    
}
@end
