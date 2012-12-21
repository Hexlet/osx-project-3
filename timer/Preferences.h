//
//  Preferences.h
//  timer
//
//  Created by Максим on 19.12.12.
//  Copyright (c) 2012 CarelessApps. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//константы для цу и пользовательских настроек
extern NSString *const Sm0_kerRestColor;
extern NSString *const Sm0_kerWorkColor;
extern NSString *const Sm0_kerRestTimeNotification;
extern NSString *const Sm0_kerWorkTimeNotification;
extern NSString *const Sm0_kerAllTimeNotification;
extern NSString *const Sm0_kerRestColorNotification;
extern NSString *const Sm0_kerWorkColorNotification;

@interface Preferences : NSWindowController {
    IBOutlet NSColorWell *restTimeColor;
    IBOutlet NSColorWell *workTimeColor;
    NSUserDefaults *defaults;
}

-(IBAction)changeWorkPieColor:(id)sender;
-(IBAction)changeRestPieColor:(id)sender;
-(IBAction)setAllToZero:(id)sender;
-(IBAction)setWorkToZero:(id)sender;
-(IBAction)setRestToZero:(id)sender;

@end
