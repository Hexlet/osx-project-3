//
//  Cell.m
//  iDNA
//
//  Created by Anatoly Yashkin on 22.12.12.
//  Copyright (c) 2012 Anatoly Yashkin. All rights reserved.
//

#import "Cell.h"
#import <ScreenSaver/ScreenSaver.h>

@implementation Cell

+(NSString *)getRandomDNA:(NSInteger)dnaLength{
    NSString *tmpString=@"";
    
    for (int i=0; i<dnaLength; i++) {
        tmpString=[tmpString stringByAppendingString:[Cell getRandomDNAPart:nil]];
    }
    
    return tmpString;
}



//Генерируем случайным образом буковку для последовательности ДНК
//удобно будет передавать в этот метод элемент, который будем менять.
+(NSString *) getRandomDNAPart:(id)replasingPart
{
    NSMutableArray *DNAParts = nil;
    int randomCounter=0;
    
    if (!DNAParts) {
        DNAParts = [NSMutableArray arrayWithObjects:@"A",@"T",@"G",@"C", nil];
    }
    
    if (replasingPart==nil) {
        randomCounter = SSRandomIntBetween(0, 3);
    }
    else
    {
        [DNAParts removeObject:replasingPart];
        randomCounter = SSRandomIntBetween(0, 2);
    }
    
    return [NSString stringWithFormat:@"%@",[DNAParts objectAtIndex:randomCounter]];
    
    
}

@end
