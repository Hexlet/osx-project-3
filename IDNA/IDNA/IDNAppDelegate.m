//
//  IDNAppDelegate.m
//  IDNA
//
//  Created by Dmitriy Zhukov on 06.01.13.
//  Copyright (c) 2013 Dmitriy Zhukov. All rights reserved.
//

#import "IDNAppDelegate.h"
#import "IDNCell.h"
#import "IDNPopulation.h"

@implementation IDNAppDelegate

-(id)init {
    self = [super init];
    if (self) {
        _populationSize=10;
        _DNALength=5;
        _mutationRate=10;
        _generationCount=0;
        _progress=50;
        _distanceToTargetDNA=0;
        _interfaceStatement = true;
        _pauseStatement = false;
        
    }
    return self;
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"DNALength"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _goalDNA = [[IDNCell alloc]init];
    [_goalDNA fillDNAArrayWithCapacity:_DNALength];
    [_goalDNAField setStringValue:[_goalDNA.DNA componentsJoinedByString:@""]];
    [self addObserver:self forKeyPath:@"DNALength" options:NSKeyValueObservingOptionOld context:@"DNALengthContext"];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != @"DNALengthContext") {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    [_goalDNA fillDNAArrayWithCapacity:_DNALength];
    [_goalDNAField setStringValue:[_goalDNA.DNA componentsJoinedByString:@""]];
}


@end
