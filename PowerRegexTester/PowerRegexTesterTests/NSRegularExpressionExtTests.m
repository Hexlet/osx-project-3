//
//  NSRegularExpressionExtTests.m
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import "NSRegularExpressionExtTests.h"
#import "NSRegularExpression+Ext.h"

@implementation NSRegularExpressionExtTests

- (void) test_allMatchesWithGroups_withEmptySource_returnsEmptyArray {
    NSRegularExpression *regex = [self regexWithPattern:@"test"];
    NSArray *matches = [regex allMatchesWithGroups:@""];
    STAssertEquals((NSUInteger)0, matches.count, nil);
}

- (void) test_allMatchesWithGroups_whenOneMatchWithoutGroups_returnsArrayOfArrayWithMatchRange {
    NSRegularExpression *regex = [self regexWithPattern:@"test"];
    NSArray *matches = [regex allMatchesWithGroups:@"the test source"];
    STAssertEquals((NSUInteger)1, matches.count, nil);
    NSArray *matchGroups = matches[0];
    STAssertEquals((NSUInteger)1, matchGroups.count, nil);
    NSRange range = [matchGroups[0] rangeValue];
    STAssertEquals(NSMakeRange(4, 4), range, nil);
}

- (void) test_allMatchesWithGroups_whenTwoMatchesWithoutGroups_returnsArrayOfTwoArraysWithMatchRanges {
    NSRegularExpression *regex = [self regexWithPattern:@"hi"];
    NSArray *matches = [regex allMatchesWithGroups:@"hi1, hi2 ..."];
    STAssertEquals((NSUInteger)2, matches.count, nil);

    NSArray *match1 = matches[0];
    STAssertEquals((NSUInteger)1, match1.count, nil);
    NSRange range1 = [match1[0] rangeValue];
    STAssertEquals(NSMakeRange(0, 2), range1, nil);
    
    NSArray *match2 = matches[1];
    STAssertEquals((NSUInteger)1, match2.count, nil);
    NSRange range2 = [match2[0] rangeValue];
    STAssertEquals(NSMakeRange(5, 2), range2, nil);
}

- (void) test_allMatchesWithGroups_whenTwoMatchesWithoutGroupsAndNewLineInSource_returnsArrayOfTwoArraysWithMatchRanges {
    NSRegularExpression *regex = [self regexWithPattern:@"a"];
    NSArray *matches = [regex allMatchesWithGroups:@"a\n\na"];
    STAssertEquals((NSUInteger)2, matches.count, nil);
    
    NSArray *match1 = matches[0];
    STAssertEquals((NSUInteger)1, match1.count, nil);
    NSRange range1 = [match1[0] rangeValue];
    STAssertEquals(NSMakeRange(0, 1), range1, nil);
    
    NSArray *match2 = matches[1];
    STAssertEquals((NSUInteger)1, match2.count, nil);
    NSRange range2 = [match2[0] rangeValue];
    STAssertEquals(NSMakeRange(3, 1), range2, nil);
}

- (void) test_allMatchesWithGroups_whenOneMatchWithGroups_returnsArrayOfArrayWithMatchRangeAndGroups {
    NSRegularExpression *regex = [self regexWithPattern:@"(an\\S*)\\D*(\\d\\d)"];
    NSArray *matches = [regex allMatchesWithGroups:@"answer is 17!"];
    STAssertEquals((NSUInteger)1, matches.count, nil);
    NSArray *matchGroups = matches[0];
    STAssertEquals((NSUInteger)3, matchGroups.count, nil);
    STAssertEquals(NSMakeRange(0, 12), [matchGroups[0] rangeValue], nil);
    STAssertEquals(NSMakeRange(0, 6), [matchGroups[1] rangeValue], nil);
    STAssertEquals(NSMakeRange(10, 2), [matchGroups[2] rangeValue], nil);
}

- (void) test_allMatchesWithGroups_whenTwoMatchesWithOneGroupEach_returnsArrayOfArrayWithMatchRangesAndGroups {
    NSRegularExpression *regex = [self regexWithPattern:@"x(\\d_\\d)"];
    NSArray *matches = [regex allMatchesWithGroups:@"x1_1 x2_2"];
    STAssertEquals((NSUInteger)2, matches.count, nil);
    
    NSArray *matchGroups1 = matches[0];
    STAssertEquals((NSUInteger)2, matchGroups1.count, nil);
    STAssertEquals(NSMakeRange(0, 4), [matchGroups1[0] rangeValue], nil);
    STAssertEquals(NSMakeRange(1, 3), [matchGroups1[1] rangeValue], nil);
    
    NSArray *matchGroups2 = matches[1];
    STAssertEquals((NSUInteger)2, matchGroups2.count, nil);
    STAssertEquals(NSMakeRange(5, 4), [matchGroups2[0] rangeValue], nil);
    STAssertEquals(NSMakeRange(6, 3), [matchGroups2[1] rangeValue], nil);
}


- (NSRegularExpression *)regexWithPattern:(NSString *)pattern {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                      options:0
                                                        error:&error];
    STAssertNil(error, nil);
    return regex;
}

@end
