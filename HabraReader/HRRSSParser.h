//
//  HRRSSParser.h
//  HabraReader
//
//  Created by Sergey on 11.11.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRRSSParser : NSObject

//+ (NSOrderedSet *)bestForTheDay;
//+ (NSet *)bestForTheWeek;
+ (void)updateRatingsInManagedObjectContext:(NSManagedObjectContext *)context withCompletionHandler:(void (^)(BOOL))completionHandler;

@end
