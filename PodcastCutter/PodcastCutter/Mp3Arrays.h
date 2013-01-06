//
//  Mp3Arrays.h
//  PodcastCutter
//
//  Created by Arthur Belous on 05.01.13.
//  Copyright (c) 2013 Arthur Belous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mp3Arrays : NSObject
{
    NSMutableArray *arrayOfMp3Index;
    NSMutableArray *arrayOfMp3Title;
    NSMutableArray *arrayOfMp3Performer;
    NSMutableArray *arrayOfMp3Track;
    NSString * MP3Performer;
    NSString * MP3Title;
}
-(void) insertIntoIndexArray:(NSString*) index;
-(void) insertIntoTitelArray:(NSString*) title;
-(void) insertIntoPerformerArray:(NSString*) performer;
-(void) insertIntoTrackArray:(NSString*) track;
-(void) setAlbumPerformer:(NSString*) albumPerformer;
-(void) setAlbumTitle:(NSString*) albumTitle;
-( NSMutableArray *) ReturnIndexArray;
-(NSMutableArray *) ReturnPerformerArray;
-(NSMutableArray*) ReturnTrackArray;
-(NSMutableArray*) ReturnTitleArray;
-(NSString*) RetMp3Performer;
-(NSString*) RetMp3Title;
@end
