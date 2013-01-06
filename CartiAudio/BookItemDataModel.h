//
//  RssRRSSData.h
//  RSSReader
//
//  Created by Nikita on 19.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookItemDataModel : NSObject //<NSCoding>
{
    NSMutableString * idb;
    NSMutableString * name;
    NSMutableString * category;
    NSMutableString * lenghtMinutes;
    NSMutableString * yearOfPublishing;
    NSMutableString * yearOfRecording;
    NSMutableString * numberOfFiles;

}
@property (nonatomic,strong) NSMutableString * idb;
@property (nonatomic,strong) NSMutableString * name;
@property (nonatomic,strong) NSMutableString * category;
@property (nonatomic,strong) NSMutableString * lenghtMinutes;
@property (nonatomic,strong) NSMutableString * yearOfPublishing;
@property (nonatomic,strong) NSMutableString * yearOfRecording;
@property (nonatomic,strong) NSMutableString * numberOfFiles;
@end
