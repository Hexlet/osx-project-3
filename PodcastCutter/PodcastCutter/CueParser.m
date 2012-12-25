//
//  CueParser.m
//  PodcastCutter
//
//  Created by Arthur Belous on 07.12.12.
//  Copyright (c) 2012 Arthur Belous. All rights reserved.
//

#import "CueParser.h"

@implementation CueParser

-(void) ParseCueFile:(NSString*)fileLocationPath
{
    trackArray = [NSMutableArray arrayWithCapacity:40] ;
    performerArray  = [NSMutableArray arrayWithCapacity:40] ;
    titleArray  = [NSMutableArray arrayWithCapacity:40] ;
    indexArray  = [NSMutableArray arrayWithCapacity:40] ;
    
    NSError *error = nil;
    NSString * cueFile  = [NSString stringWithContentsOfFile:fileLocationPath encoding:NSUTF8StringEncoding error:&error];
    NSArray* arrayOfLines = [cueFile componentsSeparatedByString:@"\n"];
    long countOfLines = arrayOfLines.count;
    NSLog(@"Lines in file are: %ld", countOfLines);
    for (int i = 3; i < arrayOfLines.count; i ++)
    {
        NSString * WordsInLine = [arrayOfLines objectAtIndex: i];

        char s = '"';
        NSString *separator = [NSString stringWithFormat:@"%c", s];
        NSArray * WordsInLineNntoArray = [WordsInLine componentsSeparatedByString:separator];
        for (int x = 0; x< WordsInLineNntoArray.count; x++)
        {
            NSString *w = [WordsInLineNntoArray objectAtIndex:x];
            NSString *withoutSpase = [w stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
           // NSLog(@"->: %@", withoutSpase);
            if ([withoutSpase hasPrefix:@"PERFORMER"])
            {
                
                NSString * twmp = [WordsInLineNntoArray objectAtIndex:x+1];
                [performerArray addObject:twmp];
                NSLog(@"%@", twmp);
            }
            if ([withoutSpase hasPrefix:@"TITLE"])
            {
                NSString * twmp = [WordsInLineNntoArray objectAtIndex:x+1];
                [titleArray addObject:twmp];
                NSLog(@"%@", twmp);
            }
            if ([withoutSpase hasPrefix:@"TRACK"])
            {
                NSString *trackArrayItem = [withoutSpase substringWithRange:NSMakeRange(6, 2)];
                NSLog(@"%@", trackArrayItem);
                [trackArray addObject:trackArrayItem];
            }
            if ([withoutSpase hasPrefix:@"INDEX"])
            {
                NSString *indexArrayItem = [withoutSpase substringFromIndex:10];
                NSLog(@"%@", indexArrayItem);
                [indexArray addObject:indexArrayItem];
            }
        }
     
    }
    
    for (int zzz=0; zzz<indexArray.count; zzz++)
    {
        
        NSString *a = [indexArray objectAtIndex:zzz];
          NSLog(@"Index ---- %@", a);
    }
    for (int zz=0; zz<trackArray.count; zz++)
    {
        NSString *b = [trackArray objectAtIndex:zz];
        NSLog(@"Track ---- %@", b);
    }
    for (int z=0; z<titleArray.count; z++)
    {
        NSString *c = [titleArray objectAtIndex:z];
        NSLog(@"Title ---- %@", c);
    }
    for (int z1=0; z1<performerArray.count; z1++)
    {
        NSString *v = [performerArray objectAtIndex:z1];
        NSLog(@"Performer ---- %@", v);
    }
    
}

-( NSMutableArray *) ReturnIndexArray
{
    return  indexArray; 
}

@end
