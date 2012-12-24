//
//  LoadSaveController.m
//  iDNA
//
//  Created by Admin on 24.12.12.
//  Copyright (c) 2012 Kabest. All rights reserved.
//

#import "LoadSaveController.h"

@implementation LoadSaveController

-(IBAction)doSave:(id)aId {
    NSSavePanel *dnaSavePanel = [NSSavePanel savePanel];
    NSInteger res = [dnaSavePanel runModal];
    if (res == NSOKButton) {
        url = [dnaSavePanel URL];
    }
}

-(IBAction)doOpen:(id)aId {
    NSOpenPanel *dnaOpenPanel = [NSOpenPanel openPanel];
    NSInteger res = [dnaOpenPanel runModal];
    if (res == NSOKButton) {
        url = [dnaOpenPanel URL];
    }
}

-(NSURL*)getURL {
    return url;
}

@end
