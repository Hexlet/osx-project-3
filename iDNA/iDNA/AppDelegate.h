//
//  AppDelegate.h
//  iDNA
//
//  Created by alex on 17/12/2012.
//  Copyright (c) 2012 alex. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Cell;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSInteger populationSize;
    NSInteger DNALength;
    NSInteger mutationRate;
}

@property Cell* DNA;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *populationSizeTextField;
@property (weak) IBOutlet NSTextField *DNALengthTextField;
@property (weak) IBOutlet NSTextField *mutationRateTextField;


@end
