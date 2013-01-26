//
//  Cell.m
//  NDA
//
//  Created by Tsyganov Stanislav on 12.11.12.
//  Copyright (c) 2012 Tsyganov Stanislav. All rights reserved.
//

#import "Cell.h"

@implementation Cell
@synthesize DNA = _DNA;

+(NSString*)stringForPrfectCellDNAWithLength:(NSInteger)length{
    //These are not the droids you are looking for...
    NSMutableArray* uglyM = [NSMutableArray arrayWithCapacity:length];
    NSArray *dnaSymbols = [NSArray arrayWithObjects:@"A", @"T", @"G", @"C", nil];
    for(int i=0; i < length; i++){
//        NSLog(@"%d", i);
        [uglyM addObject:[dnaSymbols objectAtIndex: arc4random_uniform(4)]];
    }
    return [uglyM componentsJoinedByString: @""];
}

//ACTTCGGAGATTGCACGGGACGTTGGGAGTACTCGTCCGTGGGGTTTTTAATAATAATCCGAGCGGCTTATCTCCAACGGGTAGATTGCGCATGCGAAGT
//ACTTCGGAGATTGCACGGGACGTTGGGAGTAAACGTTAGTGGGGTTTTTAATAATAATCCGAGCCGCTTATCTCCAACGGCTAGATGGAGCATGCTAAGG

-(id)initCellWithDNA:(NSMutableArray*)cellDNA{
    if (self = [super init]) {
        _DNA = [cellDNA copy];
    }
    return self;
}

-(id)initCellFromFirst:(Cell*)first andSecond:(Cell*)second{
    if (self = [super init]) {
        _DNA = [NSMutableArray arrayWithCapacity:[first.DNA count]];
        int lengthOfFirstPart = [first.DNA count] / 2;
        int lengthOfSecondPart = first.DNA.count - lengthOfFirstPart;
        NSRange firstRange;
        firstRange.location = 0;
        firstRange.length = lengthOfFirstPart;
        
        NSRange secondRange;
        secondRange.location = lengthOfFirstPart;
        secondRange.length = lengthOfSecondPart;
        
        
        [_DNA addObjectsFromArray:[first.DNA subarrayWithRange:firstRange]];
        [_DNA addObjectsFromArray:[second.DNA subarrayWithRange:secondRange]];
        
    }
    
    return self;
    
}

-(id)initWithLength:(NSInteger)length{
    if (self = [super init]) {
        _DNA = [NSMutableArray arrayWithCapacity:length];
        NSArray *dnaSymbols = [NSArray arrayWithObjects:@"A", @"T", @"G", @"C", nil];
        for(int i=0; i < length; i++){
//            NSLog(@"%d", i);
            [_DNA addObject:[dnaSymbols objectAtIndex: arc4random_uniform(4)]];
        }
        
//        NSLog(@"%@ count:%ld", _DNA, [_DNA count]);
    }
    
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        _DNA = [NSMutableArray arrayWithCapacity:kDnaLength];
        NSArray *dnaSymbols = [NSArray arrayWithObjects:@"A", @"T", @"G", @"C", nil];
        for(int i=0; i<kDnaLength; i++){
            [_DNA addObject:[dnaSymbols objectAtIndex: arc4random_uniform(4)]];
        }
    }
    return self;
}

-(int)hammingDistance:(Cell *)anotherCell{
    int answer = 0;
    for (int i = 0; i < kDnaLength; i++) {
        if (![[_DNA objectAtIndex:i] isEqual:[anotherCell.DNA objectAtIndex:i]]) {
            answer++;
        }
    }
    return answer;
}

-(int)hammingDistanceToString:(NSString *)anotherCellDNAString{
    int answer = 0;
//    NSArray* secondCellArray = [anotherCellDNAString componentsSeparatedByString:@""];
    NSUInteger length = [anotherCellDNAString length];
    for (int i = 0; i < length; i++) {
        if (![[_DNA objectAtIndex:i] isEqual:[NSString stringWithFormat:@"%C", [anotherCellDNAString characterAtIndex:i]]]) {
            answer++;
        }
    }
    return answer;
}

- (NSString *)description{
    NSMutableString* descString = [[NSMutableString alloc] init];
    NSUInteger length = [_DNA count];
    for (int i = 0; i < length; i++) {
        [descString appendString:[_DNA objectAtIndex:i]];
    }
    return [NSString stringWithString:descString];
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        [copy setDNA:[_DNA copyWithZone:zone]];
    }
    
    return copy;
}

@end
