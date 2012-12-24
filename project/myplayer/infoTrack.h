//
//  infoTrack.h
//  myplayer
//
//  Created by Дмитрий Голубев on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface infoTrack : NSObject
{
    NSString * nameArtist;
    NSString * nameAlbum;
    NSString * nameTrack;
    NSString * nameGenre;
    NSURL    * urlTrack;
    NSURL    * urlPic;
    long long len;
}

@property (nonatomic, retain) NSString * nameArtist;
@property (nonatomic, retain) NSString * nameAlbum;
@property (nonatomic, retain) NSString * nameTrack;
@property (nonatomic, retain) NSString * nameGenre;
@property (nonatomic, retain) NSURL * urlTrack;
@property (nonatomic, retain) NSURL * urlPic;
@property long long len;



-(id)init;

@end
