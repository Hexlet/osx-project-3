//
//  AppDelegate.h
//  iDNA
//
//  Created by Dmitry Davidov on 24.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property NSUInteger size;
@property NSUInteger length;
@property float mutatePercent;

@property (assign) IBOutlet NSWindow *window;

@end
