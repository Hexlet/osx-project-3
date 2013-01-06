//
//  CueParser.m
//  PodcastCutter
//
//  Created by Arthur Belous on 07.12.12.
//  Copyright (c) 2012 Arthur Belous. All rights reserved.
//

#import "CueParser.h"
#import "Mp3Arrays.h"


@implementation CueParser

-(void) ParseCueFile:(NSString*)fileLocationPath
{
    Mp3Arrays * ma = [[Mp3Arrays alloc] init]; 
    NSError *error = nil;
    NSString * cueFile  = [NSString stringWithContentsOfFile:fileLocationPath encoding:NSUTF8StringEncoding error:&error];
    NSArray* arrayOfLines = [cueFile componentsSeparatedByString:@"\n"];
    for (int s = 0; s < 4; s ++)
    {
        NSString * WordsInLine = [arrayOfLines objectAtIndex: s];
        
        char c = '"';
        NSString *separator = [NSString stringWithFormat:@"%c", c];
        NSArray * WordsInLineNntoArray = [WordsInLine componentsSeparatedByString:separator];
        for (int v = 0; v< WordsInLineNntoArray.count; v++)
        {
            NSString *w = [WordsInLineNntoArray objectAtIndex:v];
            NSString *withoutSpase = [w stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([withoutSpase hasPrefix:@"PERFORMER"])
            {
                NSString * tempPerformer = [WordsInLineNntoArray objectAtIndex:v+1];
                [ma setAlbumPerformer:tempPerformer]; 
            }
            if ([withoutSpase hasPrefix:@"TITLE"])
            {
                NSString *tempTitle = [WordsInLineNntoArray objectAtIndex:v+1];
                [ma setAlbumTitle:tempTitle];
            }
        }
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
            if ([withoutSpase hasPrefix:@"PERFORMER"])
            {
                
                NSString * trackPerformer = [WordsInLineNntoArray objectAtIndex:x+1];
                [ma insertIntoPerformerArray:trackPerformer];
            }
            if ([withoutSpase hasPrefix:@"TITLE"])
            {
                NSString * trackTitle = [WordsInLineNntoArray objectAtIndex:x+1];
                [ma insertIntoTitelArray:trackTitle];
            }
            if ([withoutSpase hasPrefix:@"TRACK"])
            {
                NSString *trackArrayItem = [withoutSpase substringWithRange:NSMakeRange(6, 2)];
                [ma insertIntoTrackArray:trackArrayItem];
            }
            if ([withoutSpase hasPrefix:@"INDEX"])
            {
                NSString *indexArrayItem = [withoutSpase substringFromIndex:10];
                [ma insertIntoIndexArray:indexArrayItem]; 
            }
        }
    }
}
}
    
@end
