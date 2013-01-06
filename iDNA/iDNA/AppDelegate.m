//
//  AppDelegate.m
//  iDNA
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //[self showGoalDNA:_goalDNA];
    // Insert code here to initialize your application
}

-(id)init {
    if (self = [super init]) {
        [self setValue:[NSNumber numberWithInteger:72] forKey:@"length"];
        _goalDNA = [[Cell alloc] initWithLength:(int) length];
        _population = nil;
        [self setValue:[NSNumber numberWithInteger:924] forKey:@"populationSize"];
    }
    return self;
}

-(void)setLength:(int) l {
    length = l;
    _goalDNA = [[Cell alloc] initWithLength:(int)length];
    [self showGoalDNA:_goalDNA];
}

-(NSInteger)length {
    return length;
}

-(NSString *)createDNAtoString:(Cell *) d {
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSString *s in _goalDNA.DNA) {
        [str appendString:s];
    }
    return str;
}

-(void)showGoalDNA:(Cell *) d {

    [_showDNA setString:[self createDNAtoString:d]];
}

- (IBAction)startEvolution:(id)sender {
    _population = [NSMutableArray arrayWithCapacity:_populationSize];
    for (int i = 0; i < _populationSize; ++i) {
        [_population addObject: [[Cell alloc] initWithLength:(int) length]];
    }
    [_pause setState:NSOffState];
    [_evolution setState:NSOnState];
    [_popSize setEditable:NO];
    [_lenghtTF setEditable:NO];
    [_mutRate setEditable:NO];
    
   // [self willChange: valuesAtIndexes:<#(NSIndexSet *)#> forKey:<#(NSString *)#>]
    
}


@end
