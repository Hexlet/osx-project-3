//
//  ResultController.m
//  iDNA
//
//  Created by Администратор on 1/6/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "ResultController.h"

@interface ResultController () {
	int generationAmount;
}
@end

@implementation ResultController

- (id) initWithGeneration:(int) g {
	self = [super initWithWindowNibName:@"Result"];
	generationAmount = g;
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

- (void)windowDidLoad
{
    [super windowDidLoad];
    [_generationPassed setStringValue:[NSString stringWithFormat:@"Total amount of generations passed to reach goal DNA -  %i", generationAmount]];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


@end
