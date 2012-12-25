//
//  Cell.m
//  Gurin_DNA
//
//  Created by Admin on 11/7/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "Cell.h"
#import "stdlib.h"

@implementation Cell
-(id) init{
    self = [super init];
    if(self){
        dna = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)createDnaElements:(int)size {
    dna = [[NSMutableArray alloc] initWithCapacity:size];
    int r;
    NSArray *arr = [NSArray arrayWithObjects:@"A",@"T",@"G",@"C",nil];
    for(NSInteger i = 0; i<size;i++)
    {
        r = arc4random()%4;
        [dna addObject:[arr objectAtIndex:r]];
    }

}

-(NSString*)description{
    NSMutableString *dnaText = [[NSMutableString alloc] init];
    if(dna) {
        for (NSString *element in dna){
            [dnaText appendString:element];
        }
    }
    return dnaText;
}

-(int)hammingDistance:(Cell *)second_dna{
    int distance = 0;
    //NSLog(@"Hamming %@",self);
    //NSLog(@"Hamming %@",second_dna);
    for(int i = 0; i<dna.count;i++){
        if(![[dna objectAtIndex:i] isEqualToString:[second_dna->dna objectAtIndex:i]]) distance++;
    }
    return distance;
}

-(Cell*)cross:(Cell *)second_dna{
    Cell* result = [[Cell alloc] init];
    int r;
    NSInteger count = dna.count;
    r = arc4random()%3;
    if(r==0){
        for(int i=0;i<count/2;i++){
            [result->dna addObject:[dna objectAtIndex:i]];
        }
        for(int i=count/2;i<count;i++){
            [result->dna addObject:[second_dna->dna objectAtIndex:i]];
        }
    }
    
    if(r==1){
        BOOL first=YES;
        for(int i =0;i<count; i++){
            if(first){
                [result->dna addObject:[dna objectAtIndex:i]];
                first=NO;
            }
            else{
                [result->dna addObject:[second_dna->dna objectAtIndex:i]];
                 first=YES;
            }
        }
    }
    
    if(r==2){
        for(int i=0;i<count*0.2;i++){
            [result->dna addObject:[dna objectAtIndex:i]];
        }
        for(int i=count*0.2;i<count*0.6;i++){
            [result->dna addObject:[second_dna->dna objectAtIndex:i]];
        }
        for(int i=count*0.6;i<count;i++){
            [result->dna addObject:[dna objectAtIndex:i]];
        }
    }
    
    //NSLog(@"Cross %@",result);
    return result;
}

@end
