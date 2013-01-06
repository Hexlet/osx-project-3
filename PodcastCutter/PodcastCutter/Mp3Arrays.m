//
//  Mp3Arrays.m
//  PodcastCutter
//
//  Created by Arthur Belous on 05.01.13.
//  Copyright (c) 2013 Arthur Belous. All rights reserved.
//

#import "Mp3Arrays.h"

@implementation Mp3Arrays
-(void) insertIntoIndexArray:(NSString*) index
{
    NSInteger indexArraySize = [arrayOfMp3Index count];
    if (indexArraySize !=0)
    {
        indexArraySize ++;
        [arrayOfMp3Index insertObject:index atIndex:indexArraySize];
    }
    else
    {
        [arrayOfMp3Index insertObject:index atIndex:indexArraySize];
    }
    
}
-(void) insertIntoTitelArray:(NSString*) title
{
    NSInteger titleArraySize = [arrayOfMp3Title count];
    if (titleArraySize !=0)
    {
        titleArraySize ++;
        [arrayOfMp3Title insertObject:title atIndex:titleArraySize];
    }
    else
    {
        [arrayOfMp3Title insertObject:title atIndex:titleArraySize];
    }
}
-(void) insertIntoPerformerArray:(NSString*) performer
{
    NSInteger PerformerArraySize = [arrayOfMp3Performer count];
    if (PerformerArraySize != 0)
    {
        PerformerArraySize ++;
        [arrayOfMp3Performer insertObject:performer atIndex:PerformerArraySize];
    }
    else
    {
        [arrayOfMp3Performer insertObject:performer atIndex:PerformerArraySize];
    }
}
-(void) insertIntoTrackArray:(NSString*) track
{
    NSInteger trackArraySize = [arrayOfMp3Track count];
    if (trackArraySize !=0)
    {
        trackArraySize ++;
        [arrayOfMp3Track insertObject:track atIndex:trackArraySize];
    }
    else
    {
        [arrayOfMp3Track insertObject:track atIndex:trackArraySize];
    }
}

-(void) setAlbumPerformer:(NSString*) albumPerformer
{
    MP3Performer = albumPerformer; 
}
-(void) setAlbumTitle:(NSString*) albumTitle
{
    MP3Title = albumTitle;
}

-( NSMutableArray *) ReturnIndexArray
{
    return arrayOfMp3Index; 
}
-(NSMutableArray *) ReturnPerformerArray
{
    return arrayOfMp3Performer; 
}
-(NSMutableArray*) ReturnTrackArray
{
    return arrayOfMp3Track;
}
-(NSMutableArray*) ReturnTitleArray
{
    return arrayOfMp3Title;
}
-(NSString*) RetMp3Performer
{
    return MP3Performer;
}
-(NSString*) RetMp3Title
{
    return MP3Title;
}

@end
