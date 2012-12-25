//
//  Regex.m
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import "Regex.h"

@implementation Regex

- (NSArray *) allMatchesWithGroups:(NSString *)source {
    NSArray *allMatches = [self allMatches:source];
    NSMutableArray *matches = [NSMutableArray array];
    if (!allMatches) {
        return matches;
    }
    for (NSTextCheckingResult *match in allMatches) {
        NSArray *groups = [self groupsFromSourceString:source withMatch:match];
        [matches addObject:groups];
    }
    return matches;
}

- (NSArray *) groupsFromSourceString:(NSString *)source withMatch:(NSTextCheckingResult *)match  {
    if (!match) { return [NSArray array]; }
    NSMutableArray *groups = [NSMutableArray array];
    for (int index = 1; index < [match numberOfRanges]; index++) {
        NSString *matchString = [source substringWithRange:[match rangeAtIndex:index]];
        [groups addObject:matchString];
    }
    return groups;
    
}

- (NSArray *) allMatches:(NSString *)source {
    return [self.regex matchesInString:source options:0 range:NSMakeRange(0, source.length)];
}

@end
