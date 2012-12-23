//
//  FileDialog.m
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import "FileDialog.h"

@implementation FileDialog

- (NSURL *) openFile {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseDirectories = NO;
    openPanel.canChooseFiles = YES;
    openPanel.resolvesAliases = YES;
    openPanel.title = @"Select a folder for your CD content.";
    openPanel.prompt = @"Select";
    openPanel.delegate = self;
    
    if ([openPanel runModal] == NSOKButton) {
        return openPanel.URL;
    }
    return nil;
}

@end
