//
//  AppDelegate.m
//  iDNA
//
//  Created by alex on 17/12/2012.
//  Copyright (c) 2012 alex. All rights reserved.
//

#import "AppDelegate.h"
#import "Cell.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(id)init {
    if (self = [super init]) {
        [self setValue:[NSNumber numberWithInt:0] forKey:@"populationSize"];
        [self setValue:[NSNumber numberWithInt:arc4random()%100] forKey:@"DNALength"];
        [self setValue:[NSNumber numberWithInt:0] forKey:@"mutationRate"];
    }
    
    return self;
}


/*
-(void)setPopulationSize:(int)size
{
    [_populationSizeTextField setStringValue:[NSString stringWithFormat:@"%d", size]];
    populationSize = size;
}

-(NSInteger)populationSize
{
    return populationSize;
}
*/

@end
