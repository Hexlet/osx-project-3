//
//  ResultsItemTests.m
//  PowerRegexTester
//
//  Created by Igor on 12/23/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import "ResultsItemTests.h"
#import "ResultsItem.h"

@implementation ResultsItemTests

-(void) test_initWithStringRangeAndLevel_allPropertiesSet {
    ResultsItem *item = [[ResultsItem alloc] initWithString:@"test"
                                              rangeInSource:NSMakeRange(1, 5)
                                                 groupLevel:1];
    STAssertEquals(@"test", item.string, nil);
    STAssertEquals(NSMakeRange(1, 5), item.rangeInSource, nil);
    STAssertEquals((NSUInteger)1, item.groupLevel, nil);
}

-(void)test_copy {
    NSString *string = @"test";
    NSRange range = NSMakeRange(1, 2);
    NSUInteger level = 1;
    ResultsItem *item = [[ResultsItem alloc] initWithString:string rangeInSource:range groupLevel:level];
    ResultsItem *itemCopy = [item copy];
    STAssertEqualObjects(string, itemCopy.string, nil);
    STAssertEquals(level, itemCopy.groupLevel, nil);
    STAssertEquals(range, itemCopy.rangeInSource, nil);
}

-(void)test_description_whenLevelIs0_returnsStringProperty {
    NSString *string = @"the test";
    NSRange range = NSMakeRange(0, 1);
    NSUInteger level = 0;
    ResultsItem *item = [[ResultsItem alloc] initWithString:string rangeInSource:range groupLevel:level];
    STAssertEqualObjects(string, item.description, nil);
}

-(void)test_description_whenLevelIs1_returnsTabAndStringProperty {
    NSString *string = @"test";
    NSRange range = NSMakeRange(0, 1);
    NSUInteger level = 1;
    ResultsItem *item = [[ResultsItem alloc] initWithString:string rangeInSource:range groupLevel:level];
    STAssertEqualObjects(@"\ttest", item.description, nil);
}

-(void)test_resultsItemsFromMatchesWithGroups_withEmptyArray_returnsEmptyArray {
    NSArray *empty = [NSArray array];
    NSArray *resultItems = [ResultsItem resultsItemsFromMatchesWithGroups:empty andSourceString:@"test"];
    STAssertEquals((NSUInteger)0, resultItems.count, nil);
}

-(void)test_resultsItemsFromMatchesWithGroups_forMatchesWithoutGroups {
    NSRange range1 = NSMakeRange(0, 2);
    NSRange range2 = NSMakeRange(2, 1);
    NSArray *matches = @[ @[ [NSValue valueWithRange:range1] ], @[ [NSValue valueWithRange:range2] ] ];
    NSArray *resultItems = [ResultsItem resultsItemsFromMatchesWithGroups:matches andSourceString:@"test"];
    STAssertEquals((NSUInteger)2, resultItems.count, nil);
    
    ResultsItem *item1 = resultItems[0];
    STAssertEquals(range1, item1.rangeInSource, nil);
    STAssertEqualObjects(@"te", item1.string, nil);
    STAssertEquals((NSUInteger)0, item1.groupLevel, nil);
    
    ResultsItem *item2 = resultItems[1];
    STAssertEquals(range2, item2.rangeInSource, nil);
    STAssertEqualObjects(@"s", item2.string, nil);
    STAssertEquals((NSUInteger)0, item2.groupLevel, nil);
}

-(void)test_resultsItemsFromMatchesWithGroups_forMatchWithGroups {
    NSRange matchRange = NSMakeRange(0, 6);
    NSRange groupRange1 = NSMakeRange(1, 2);
    NSRange groupRange2 = NSMakeRange(3, 3);
    NSArray *matches = @[ @[ [NSValue valueWithRange:matchRange], [NSValue valueWithRange:groupRange1], [NSValue valueWithRange:groupRange2] ] ];
    NSArray *resultItems = [ResultsItem resultsItemsFromMatchesWithGroups:matches andSourceString:@"test string"];
    STAssertEquals((NSUInteger)3, resultItems.count, nil);
    
    ResultsItem *matchItem = resultItems[0];
    STAssertEquals(matchRange, matchItem.rangeInSource, nil);
    STAssertEqualObjects(@"test s", matchItem.string, nil);
    STAssertEquals((NSUInteger)0, matchItem.groupLevel, nil);

    ResultsItem *groupItem1 = resultItems[1];
    STAssertEquals(groupRange1, groupItem1.rangeInSource, nil);
    STAssertEqualObjects(@"es", groupItem1.string, nil);
    STAssertEquals((NSUInteger)1, groupItem1.groupLevel, nil);

    ResultsItem *groupItem2 = resultItems[2];
    STAssertEquals(groupRange2, groupItem2.rangeInSource, nil);
    STAssertEqualObjects(@"t s", groupItem2.string, nil);
    STAssertEquals((NSUInteger)1, groupItem2.groupLevel, nil);
}

@end
