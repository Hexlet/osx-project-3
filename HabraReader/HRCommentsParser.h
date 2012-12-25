//
//  HRCommentsParser.h
//  HabraReader
//
//  Created by Sergey Starukhin on 18.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Post;

@interface HRCommentsParser : NSObject

+ (void)parseCommentsForPost:(Post *)post fromString:(NSString *)comments;

@end
