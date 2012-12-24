//
//  infoTrack.m
//  myplayer
//
//  Created by Сергей Голубев on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "infoTrack.h"

@implementation infoTrack

@synthesize nameArtist;
@synthesize nameAlbum;
@synthesize nameTrack;
@synthesize nameGenre;
@synthesize urlTrack;
@synthesize urlPic;
@synthesize len;


-(id)init
{
    NSLog(@"init info Track");
    nameArtist = [[NSString alloc]init];
    nameAlbum  = [[NSString alloc]init];
    nameGenre  = [[NSString alloc]init];
    nameTrack =  [[NSString alloc]init];
    urlTrack   = [[NSURL alloc]init];
    urlPic     = [[NSURL alloc]init];
    return self;
}


@end
