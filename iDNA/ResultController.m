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

- (void)windowDidLoad
{
    [super windowDidLoad];
    NSString *output;
    output = [[NSString alloc] initWithFormat:@"Cell like Goal DNA was found at %i generation", countOfGeneration];
    [tfResultLabel setStringValue:output];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
} 

@end
