ы//
//  Preferences.m
//  timer
//
//  Created by Максим on 19.12.12.
//  Copyright (c) 2012 CarelessApps. All rights reserved.
//

#import "Preferences.h"
#import "AppDelegate.h"
#import "Preferences.h"

@implementation Preferences

NSString *const Sm0_kerRestColor = @"Sm0_kerRestColor";
NSString *const Sm0_kerWorkColor = @"Sm0_kerWorkColor";
NSString *const Sm0_kerRestTimeNotification = @"Sm0_kerRestTimeNotification";
NSString *const Sm0_kerWorkTimeNotification = @"Sm0_kerWorkTimeNotification";
NSString *const Sm0_kerAllTimeNotification = @"Sm0_kerAllTimeNotification";
NSString *const Sm0_kerRestColorNotification = @"Sm0_kerRestColorNotification";
NSString *const Sm0_kerWorkColorNotification = @"Sm0_kerWorkColorNotification";

-(id)init{
    self = [super initWithWindowNibName:@"Preferences"];
    return self;
}
-(void)windowDidLoad{
    NSData *workData = [[NSUserDefaults standardUserDefaults] objectForKey:Sm0_kerWorkColor];
    NSData *restData = [[NSUserDefaults standardUserDefaults] objectForKey:Sm0_kerRestColor];
    [restTimeColor setColor:[NSKeyedUnarchiver unarchiveObjectWithData:restData]];
    [workTimeColor setColor:[NSKeyedUnarchiver unarchiveObjectWithData:workData]];
}

-(IBAction)changeWorkPieColor:(id)sender{
    defaults = [NSUserDefaults standardUserDefaults];
    NSData *workColorData = [NSKeyedArchiver archivedDataWithRootObject:[workTimeColor color]];
    [defaults setObject:workColorData forKey:Sm0_kerWorkColor];
    [defaults synchronize];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *d = [NSDictionary dictionaryWithObject:[workTimeColor color] forKey:@"workTimeColor"];
    [nc postNotificationName:Sm0_kerWorkColorNotification object:self userInfo:d];
}
-(IBAction)changeRestPieColor:(id)sender{
    defaults = [NSUserDefaults standardUserDefaults];
    NSData *restColorData = [NSKeyedArchiver archivedDataWithRootObject:[restTimeColor color]];
    [defaults setObject:restColorData forKey:Sm0_kerRestColor];
    [defaults synchronize];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *d = [NSDictionary dictionaryWithObject:[restTimeColor color] forKey:@"restTimeColor"];
    [nc postNotificationName:Sm0_kerRestColorNotification object:self userInfo:d];
}
-(IBAction)setAllToZero:(id)sender{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"summ"];
    [defaults setInteger:0 forKey:@"rest"];
    [defaults setInteger:0 forKey:@"work"];
    [defaults synchronize];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:Sm0_kerAllTimeNotification object:self userInfo:nil];
}
-(IBAction)setWorkToZero:(id)sender{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"work"];
    [defaults synchronize];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:Sm0_kerWorkTimeNotification object:self userInfo:nil];
}
-(IBAction)setRestToZero:(id)sender{
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"rest"];
    [defaults synchronize];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:Sm0_kerRestTimeNotification object:self userInfo:nil];
}


@end
