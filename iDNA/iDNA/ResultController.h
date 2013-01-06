//
//  ResultController.h
//  iDNA
//
//  Created by Администратор on 1/6/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ResultController : NSWindowController

@property (weak) IBOutlet NSTextField *generationPassed;

- (id) initWithGeneration:(int) g;

@end
