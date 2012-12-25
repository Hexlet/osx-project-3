//
//  AppDelegate.h
//  passwordGenerator
//
//  Created by padawan on 25.12.12.
//  Copyright (c) 2012 padawan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray *upperCaseSymbol, *lowerCase, *numberCase;
    int upperCaseCheck, numberCaseCheck;
}

@property NSNumber *lengthPassword;
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *lengthField;
@property (weak) IBOutlet NSTextField *passwordField;

- (IBAction)clickOnUpperCase:(id)sender;
- (IBAction)clickeOnNumberCase:(id)sender;
- (IBAction)clickGenerate:(id)sender;

@end
