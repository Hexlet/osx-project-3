//
//  AppDelegate.h
//  105
//
//  Created by Stas on 12/15/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    IBOutlet NSTextField *monitor;
    IBOutlet NSTextField *status;
    IBOutlet NSSlider *sliPopSizeDisplay;
    IBOutlet NSSlider *sliDnaLengthDisplay;
    IBOutlet NSSlider *sliMutationRateDisplay;
    IBOutlet NSButton *startEvolutionDisplay;
    
    int popSize;
    int mutRate;
    int dnaLengthBindings;                      // эта переменная нужна только для связывания слайдера и текстового поля (DNA length)
}

extern int dnaLength;

@property (assign) IBOutlet NSWindow *window;

- (IBAction)sliDnaLength:(id)sender;
- (IBAction)startEvolution:(id)sender;
- (IBAction)tfDnaLength:(id)sender;

@end
