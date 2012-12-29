//
//  Document.h
//  iDNA
//
//  Created by Stas on 12/26/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument {
    NSInteger controlPopSize;
    NSInteger controlDnaLength;
    NSInteger controlMutRate;
    IBOutlet NSTextField *tfMonitor;
    IBOutlet NSTextField *lbgeneration;
    IBOutlet NSProgressIndicator *piBestMatchHdPop;
    IBOutlet NSProgressIndicator *piBestMatchHdGen;
    BOOL pauseFlag;
    IBOutlet NSButton *startEvolutionDisplay;
    IBOutlet NSTextField *tfPopSizeDisplay;
    IBOutlet NSTextField *tfDnaLengthDisplay;
    IBOutlet NSSlider *sliPopSizeDisplay;
    IBOutlet NSSlider *sliDnaLengthDisplay;
    IBOutlet NSButton *pauseDisplay;
    
}

- (IBAction)sliDnaLength:(id)sender;
- (IBAction)tfDnaLength:(id)sender;
- (IBAction)startEvolution:(id)sender;
- (IBAction)pause:(id)sender;

@end
