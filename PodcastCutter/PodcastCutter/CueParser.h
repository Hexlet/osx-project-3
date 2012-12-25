//
//  CueParser.h
//  PodcastCutter
//
//  Created by Arthur Belous on 07.12.12.
//  Copyright (c) 2012 Arthur Belous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CueParser : NSObject
{
    NSMutableArray* trackArray;
    NSMutableArray* performerArray ;
    NSMutableArray* titleArray ;
    NSMutableArray* indexArray ;
    
}
 
-(void) ParseCueFile:(NSString *)Filepath;
-( NSMutableArray *) ReturnIndexArray;
- (NSMutableArray *) ReturnPerformerArray; 

@end