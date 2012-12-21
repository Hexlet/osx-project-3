//
//  updateSecond.m
//  timer
//
//  Created by Максим on 18.12.12.
//  Copyright (c) 2012 CarelessApps. All rights reserved.
//

#import "updateSecond.h"
#import "AppDelegate.h"

@implementation updateSecond

-(void)updateString:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:([defaults integerForKey:key]+1) forKey:key];
    [defaults setInteger:([defaults integerForKey:@"work"]+[defaults integerForKey:@"rest"]) forKey:@"summ"];
    [self makeStandartTimeView:key];
}

-(NSString *)makeStandartTimeView:(NSString *)key{
    NSInteger secondsAll = [[NSUserDefaults standardUserDefaults]integerForKey:key];
    NSInteger minutes, seconds;
    minutes = secondsAll/60;
    seconds = secondsAll%60;
    if (seconds < 10) {
        NSString *secondStr = [NSString stringWithFormat:@"0%li",seconds];
        _timeLeft = [NSString stringWithFormat:@"%li:%@",minutes,secondStr];
    }
    else {
        _timeLeft = [NSString stringWithFormat:@"%li:%li",minutes,seconds];
    }
    return _timeLeft;
}
-(NSString *)print{
    return _timeLeft;
}



@end
