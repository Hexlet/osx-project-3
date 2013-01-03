//
//  ResultController.h
//  iDNA
//
//  Created by Stas on 12/28/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResultController : NSWindowController {
    IBOutlet NSTextField *tfResultLabel;
    IBOutlet NSTextField *tfResultLabelTime;
    
}

extern int countOfGeneration;       // дотягиваемся к этой переменной из "Document.m"

@end
