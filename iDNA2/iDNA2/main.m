//
//  main.m
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 03.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    @try {
        return NSApplicationMain(argc, (const char **)argv);
    }
    @catch (NSException *exception) {
        NSLog(@"can't return NSApplicationMain");
    }
}
