//
//  AppDelegate.m
//  Project_3
//
//  Created by Admin on 12/23/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.conf = [[Configuration alloc] init];
    [self.populationSizeSlider setFloatValue:self.conf.popultaionSize];
    [self.populationSizeField setFloatValue:self.conf.popultaionSize];
    [self.dnaLenSlider setFloatValue:self.conf.dnaLen];
    [self.dnaLenField setFloatValue:self.conf.dnaLen];
    [self.mutRateSlider setFloatValue:self.conf.mutRate];
    [self.mutRateField setFloatValue:self.conf.mutRate];
    
    self.goalDNA = [[Cell alloc] init];
    [self.goalDNA createDnaElements:self.conf.dnaLen];
    [self.goalDnaText setStringValue:[self.goalDNA description]];
    _pauseEvol = NO;
}

- (IBAction)populationSizeChanged:(id)sender {
    float newValue = [sender floatValue];
    self.conf.popultaionSize = newValue;
    [self.populationSizeSlider setFloatValue:self.conf.popultaionSize];
    [self.populationSizeField setFloatValue:self.conf.popultaionSize];
    
}

- (IBAction)dnaLengthChanged:(id)sender {
    float newValue = [sender floatValue];
    self.conf.dnaLen = newValue;
    [self.dnaLenSlider setFloatValue:self.conf.dnaLen];
    [self.dnaLenField setFloatValue:self.conf.dnaLen];
    
    [self.goalDNA createDnaElements:self.conf.dnaLen];
    [self.goalDnaText setStringValue:[self.goalDNA description]];
}

- (IBAction)mutRateChanged:(id)sender {
    float newValue = [sender floatValue];
    self.conf.mutRate = newValue;
    [self.mutRateSlider setFloatValue:self.conf.mutRate];
    [self.mutRateField setFloatValue:self.conf.mutRate];
}

- (IBAction)startEvolution:(id)sender {
    _population = [[NSMutableArray alloc] initWithCapacity:_conf.popultaionSize];
    for(int i=0;i<_conf.popultaionSize;i++){
        Cell *cell = [[Cell alloc] init];
        [cell createDnaElements:_conf.dnaLen];
        [_population addObject:cell];
    }
    if([_populationSizeField isEnabled]) [_populationSizeField setEnabled:NO];
    if([_populationSizeSlider isEnabled]) [_populationSizeSlider setEnabled:NO];
    if([_dnaLenField isEnabled]) [_dnaLenField setEnabled:NO];
    if([_dnaLenSlider isEnabled]) [_dnaLenSlider setEnabled:NO];
    if([_mutRateField isEnabled]) [_mutRateField setEnabled:NO];
    if([_mutRateSlider isEnabled]) [_mutRateSlider setEnabled:NO];
    if([_start isEnabled]) [_start setEnabled:NO];
    if([_loadDna isEnabled]) [_loadDna setEnabled:NO];
    if(![_pause isEnabled]) [_pause setEnabled:YES];
    
    
    //[NSThread detachNewThreadSelector:@selector(evolution) toTarget:self withObject:nil];
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(evolution)
                                                   object:nil];
    [myThread start];  // Actually create the thread
}

-(void)evolution{
    while(true){
        if(_pauseEvol) continue;
        [_population sortUsingComparator:^(Cell *obj1, Cell *obj2) {
            
            if ([obj1 hammingDistance:_goalDNA] > [obj2 hammingDistance:_goalDNA]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 hammingDistance:_goalDNA] < [obj2 hammingDistance:_goalDNA]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        NSLog(@"%i",[[_population objectAtIndex:0] hammingDistance:_goalDNA]);
        if([[_population objectAtIndex:0] hammingDistance:_goalDNA]==0) break;
                
        NSInteger count = _population.count;        
        NSMutableArray *populationTest = [[NSMutableArray alloc] initWithCapacity:count/2];
        for(int i=0;i<count/2;i++){
            [populationTest addObject:[NSNumber numberWithBool:NO]];
        }
        int r;
        Cell *first,*second;
        
        for(int i = 0;i<(count/2);i++){
            first = [_population objectAtIndex:i];
            r = arc4random()%(count/2);
            if(i!=r && ![[populationTest objectAtIndex:r] boolValue]){
                second = [_population objectAtIndex:r];
                [populationTest replaceObjectAtIndex:r withObject:[NSNumber numberWithBool:YES]];
            }
            else{
                while(true){
                    r++;
                    if(r==count/2)r=0;
                    if(i!=r && ![[populationTest objectAtIndex:r] boolValue]){
                        second = [_population objectAtIndex:r];
                        [populationTest replaceObjectAtIndex:r withObject:[NSNumber numberWithBool:YES]];
                        break;
                    }
                }
            }
            
            [_population replaceObjectAtIndex:(count/2)+i withObject:[first cross:second]];
        }       
        for(int i=0;i<count;i++){
            [[_population objectAtIndex:i] mutate:_conf.mutRate];
        }
    }
    NSLog(@"end");
}

- (IBAction)pauseEvolution:(id)sender {
    if(!_pauseEvol) {
        _pauseEvol = YES;
        [_pause setTitle:@"Continue"];
    }
    else {
        _pauseEvol = NO;
        [_pause setTitle:@"Pause"];
    }
    
}
@end
