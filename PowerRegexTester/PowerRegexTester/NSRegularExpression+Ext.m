//
//  NSRegularExpression+Ext.m
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import "NSRegularExpression+Ext.h"

@implementation NSRegularExpression (Ext)

- (NSArray *) allMatchesWithGroups:(NSString *)source
{
    NSMutableArray *result = [NSMutableArray array];
    NSArray *allMatches = [self matchesFromSourceString:source];
    if (!allMatches) {
        return result;
    }
    for (NSTextCheckingResult *match in allMatches) {
        NSArray *groups = [self groupsFromMatch:match];
        [result addObject:groups];
    }
    return result;
}

- (NSArray *) matchesFromSourceString:(NSString *)source
{
    return [self matchesInString:source options:0 range:NSMakeRange(0, source.length)];
}

- (NSArray *) groupsFromMatch:(NSTextCheckingResult *)match
{
    if (!match) {
        return [NSArray array];
    }
    NSMutableArray *groups = [NSMutableArray array];
    for (int index = 0; index < match.numberOfRanges; index++) {
        NSRange range = [match rangeAtIndex:index];
        [groups addObject:[NSValue valueWithRange:range]];
    }
    return groups;
}

@end