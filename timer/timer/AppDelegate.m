//
//  AppDelegate.m
//  timer
//
//  Created by Максим on 20.11.12.
//  Copyright (c) 2012 CarelessApps. All rights reserved.
//

#import "AppDelegate.h"
#import "updateSecond.h"
#import "Preferences.h"
#define PI 3.14159265358979323846

@implementation AppDelegate

-(id)init{
    if (self = [super init]) {
        //цу от настроек
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(updateRest:) name:Sm0_kerRestTimeNotification object:nil];
        [nc addObserver:self selector:@selector(updateWork:) name:Sm0_kerWorkTimeNotification object:nil];
        [nc addObserver:self selector:@selector(updateAllLables:) name:Sm0_kerAllTimeNotification object:nil];
        [nc addObserver:self selector:@selector(changerestColor:) name:Sm0_kerRestColorNotification object:nil];
        [nc addObserver:self selector:@selector(changeworkColor:) name:Sm0_kerWorkColorNotification object:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:Sm0_kerWorkColor] == nil || [defaults objectForKey:Sm0_kerRestColor] == 0) {
            NSData *workColorData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor blueColor]];
            [defaults setObject:workColorData forKey:Sm0_kerWorkColor];
            NSData *restColorData = [NSKeyedArchiver archivedDataWithRootObject:[NSColor greenColor]];
            [defaults setObject:restColorData forKey:Sm0_kerRestColor];
            [defaults synchronize];
        }
    }
    return self;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    updateSecond *update = [[updateSecond alloc]init];
    [update updateString:@"rest"];
    [restLable setStringValue:[NSString stringWithFormat:@"%@",[update print]]];
    [update updateString:@"work"];
    [workLable setStringValue:[NSString stringWithFormat:@"%@",[update print]]];
    [update updateString:@"summ"];
    [summ setStringValue:[NSString stringWithFormat:@"%@",[update print]]];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(summ) userInfo:nil repeats:YES];
    [self drawPie:[self restColor]:[self workColor]];
}
-(void)summ{
    updateSecond *update = [[updateSecond alloc]init];
    [update updateString:@"summ"];
    [summ setStringValue:[NSString stringWithFormat:@"%@",[update print]]];
}
-(IBAction)rest:(id)sender{
    [workTimer invalidate];
    updateSecond *update = [[updateSecond alloc]init];
    [update updateString:@"rest"];
    restTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(rest:) userInfo:nil repeats:NO];
    [restButton setEnabled:NO];
    [workButton setEnabled:YES];
    [restLable setStringValue:[NSString stringWithFormat:@"%@",[update print]]];
    [self drawPie:[self restColor]:[self workColor]];
}
-(IBAction)work:(id)sender{
    [restTimer invalidate];
    updateSecond *update = [[updateSecond alloc]init];
    [update updateString:@"work"];
    workTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(work:) userInfo:nil repeats:NO];
    [restButton setEnabled:YES];
    [workButton setEnabled:NO];
    [workLable setStringValue:[NSString stringWithFormat:@"%@",[update print]]];
    [self drawPie:[self restColor]:[self workColor]];
}

//метод рисует круговую диаграмму
-(void)drawPie:(NSColor *)rest:(NSColor *)work{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat works,summs,rests;
    works = (int)[defaults integerForKey:@"work"];
    summs = (int)[defaults integerForKey:@"summ"];
    rests = (int)[defaults integerForKey:@"rest"];
    float percent, persentW,persentR;
    percent = (works/summs)*360;
    int degree = (int)percent;
    persentW = (works/summs)*100;
    persentR = (rests/summs)*100;
    //проценты слева и справа от диаграммы
    [workPersent setStringValue:[NSString stringWithFormat:@"%1.2f%%",persentW]];
    [restPersent setStringValue:[NSString stringWithFormat:@"%1.2f%%",persentR]];
    
    NSLog(@"%f, %f, %i",works,summs,degree);
    
    NSBezierPath *greenPath = [NSBezierPath bezierPath];
    [greenPath setLineWidth:2];
    
    [greenPath moveToPoint: NSMakePoint(412/2, 88)];
    
    [greenPath appendBezierPathWithArcWithCenter:NSMakePoint(412/2, 88) radius:80 startAngle:0 endAngle: 360];
    
    [greenPath lineToPoint: NSMakePoint(412/2,88)];
    [greenPath stroke];
    
    [rest set];
    [greenPath fill];
    
    greenPath = [NSBezierPath bezierPath];
    [[NSColor blackColor] set];
    [greenPath setLineWidth:2];
    
    [greenPath moveToPoint: NSMakePoint(412/2,88)];
    
    [greenPath appendBezierPathWithArcWithCenter:NSMakePoint(412/2,88) radius:80 startAngle:degree  endAngle:360];
    [greenPath lineToPoint: NSMakePoint(412/2,88)];
    [greenPath stroke];
    [work set];
    
    [greenPath fill];
}
-(void)changeworkColor:(NSNotification *)n{
    NSColor *workColor = [[n userInfo]objectForKey:@"workTimeColor"];
    [self drawPie:[self restColor]:workColor];
}
-(void)changerestColor:(NSNotification *)n{
    NSColor *restColor = [[n userInfo]objectForKey:@"restTimeColor"];
    [self drawPie:restColor:[self workColor]];
}
-(void)updateRest:(NSNotification *)n{
    [restLable setStringValue:@"0:00"];
}
-(void)updateWork:(NSNotification *)n{
    [workLable setStringValue:@"0:00"];
}
-(void)updateAllLables:(NSNotification *)n{
    [restLable setStringValue:@"0:00"];
    [workLable setStringValue:@"0:00"];
    [summ setStringValue:@"0:00"];
}
-(NSColor *)restColor {
    NSData *restData = [[NSUserDefaults standardUserDefaults]objectForKey:Sm0_kerRestColor];
    return [NSKeyedUnarchiver unarchiveObjectWithData:restData];
}
-(NSColor *)workColor{
    NSData *workColor = [[NSUserDefaults standardUserDefaults]objectForKey:Sm0_kerWorkColor];
    return [NSKeyedUnarchiver unarchiveObjectWithData:workColor];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
