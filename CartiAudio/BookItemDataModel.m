//
//  RssRRSSData.m
//  RSSReader
//
//  Created by Nikita on 19.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BookItemDataModel.h"

@implementation BookItemDataModel

@synthesize  idb;
@synthesize  name;
@synthesize  category;
@synthesize  lenghtMinutes;
@synthesize  yearOfPublishing;
@synthesize  yearOfRecording;
@synthesize  numberOfFiles;

-(void) setData:(BookItemDataModel *) loadedData
{
    self.idb=[loadedData idb];
    self.name=[loadedData name];
    self.category=[loadedData category];
    self.lenghtMinutes=[loadedData lenghtMinutes];
    self.yearOfRecording=[loadedData yearOfRecording];
    self.yearOfPublishing=[loadedData yearOfPublishing];
    self.numberOfFiles=[loadedData numberOfFiles];
}
/*
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:artTitle forKey:@"artTitle"];

    [aCoder encodeObject:artDate forKey:@"artDate"];
    [aCoder encodeObject:artUrl forKey:@"artUrl"];
    [aCoder encodeObject:artDescription forKey:@"artDescription"];
    [aCoder encodeObject:artImgUrl forKey:@"artImgUrl"];
    NSData * imgData = UIImageJPEGRepresentation(artImage, 1.0);//UIImagePNGRepresentation(self.artImage);
    [aCoder encodeObject:imgData forKey:@"artImageData"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init]) == nil) 
    {
		return self;
	} // end if 
    self.artTitle = [aDecoder decodeObjectForKey:@"artTitle"];
    self.artDate = [aDecoder decodeObjectForKey:@"artDate"];
    self.artUrl = [aDecoder decodeObjectForKey:@"artUrl"];
    self.artDescription = [aDecoder decodeObjectForKey:@"artDescription"];
    self.artImgUrl = [aDecoder decodeObjectForKey:@"artImgUrl"];
    NSData * imgData = [aDecoder decodeObjectForKey:@"artImageData"];
    self.artImage = [UIImage imageWithData:imgData];
    return self;
}

-(void)dealloc
{
    NSLog(@"dataModel dealloc");
    self.artUrl = nil;
    self.artImgUrl = nil;
    self.artDate = nil;
    self.artTitle = nil;
    self.artDescription = nil;
    //[artImage release];
    [super dealloc];
}
*/
@end
