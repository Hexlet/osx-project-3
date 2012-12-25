//
//  ResultsItem.h
//  PowerRegexTester
//
//  Created by Igor on 12/23/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
An item in the Results table
*/
@interface ResultsItem : NSObject <NSCopying>

@property (readonly) NSString *string;
@property (readonly) NSRange rangeInSource;
@property (readonly) NSUInteger groupLevel;

-(id) initWithString:(NSString *)string
       rangeInSource:(NSRange)range
          groupLevel:(NSUInteger)level;

+(NSArray *)resultsItemsFromMatchesWithGroups:(NSArray *)matchesWithGroups
                              andSourceString:(NSString *)sourceString;

@end
