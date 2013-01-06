//
//  AppDelegate.h
//  iDNA
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSUInteger length;
}

@property NSUInteger populationSize;
@property (strong) Cell *goalDNA;
@property NSMutableArray *population;

@property (unsafe_unretained) IBOutlet NSTextView *showDNA;

@property (assign) IBOutlet NSWindow *window;

- (IBAction)startEvolution:(id)sender;

@property (weak) IBOutlet NSTextField *popSize;
@property (weak) IBOutlet NSTextField *lenghtTF;
@property (weak) IBOutlet NSTextField *mutRate;
@property (weak) IBOutlet NSButton *pause;
@property (weak) IBOutlet NSButton *evolution;




@end
