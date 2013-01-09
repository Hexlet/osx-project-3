//
//  ResultController.m
//  iDNA
//
//  Created by Stas on 12/28/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import "ResultController.h"

@interface ResultController () 

@end

@implementation ResultController

-(id) init  {
    self = [super initWithWindowNibName:@"Result"];
    return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

NSInteger correction = 0; // нужно для корректного отображения прошедшего времени в последующих (не первых) запусках эволюции

- (void)windowDidLoad
{
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [super windowDidLoad];
    NSString *output, *outputTime, *string;
    output = [[NSString alloc] initWithFormat:@"Cell like Goal DNA was found at %i generation", countOfGeneration];
    NSInteger timeInSec = clock() / CLOCKS_PER_SEC - correction;
    string = timeInSec > 1 ? [[NSString alloc] initWithFormat:@"seconds"] : [[NSString alloc] initWithFormat:@"second"];
    outputTime = [[NSString alloc] initWithFormat:@"Time passed: %ld %@", timeInSec, string];
    [tfResultLabel setStringValue:output];
    [tfResultLabelTime setStringValue:outputTime];
    correction = timeInSec + correction;
}

@end
