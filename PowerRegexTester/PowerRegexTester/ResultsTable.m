//
//  ResultsTableViewController.m
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import "ResultsTable.h"
#import "ResultsItem.h"

@implementation ResultsTable
{
    NSString *sourceString;
    NSArray *resultsItems;
}

- (void) setSourceString:(NSString *)string
      andRangesOfMatches:(NSArray *)matches
{
    resultsItems = [ResultsItem resultsItemsFromMatchesWithGroups:matches andSourceString:string];
}

- (BOOL) noMatch {
    return resultsItems.count == 0;
}

#pragma mark == NSTableViewDataSource implementation ==
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSUInteger resultsCount = resultsItems.count;
    return resultsCount > 0 ? resultsCount : 1;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([self noMatch]) {
        return @"No match.";
    }
    return resultsItems[row];
}

#pragma mark == NSTableViewDelegate implementation ==
- (BOOL) tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    return [self isGroupRow:row];
}

- (void)tableView:(NSTableView *)tableView
  willDisplayCell:(id)cell
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    NSTextFieldCell *textCell = (NSTextFieldCell *)cell;
    if ([self noMatch]) {
        textCell.textColor = [NSColor grayColor];
        textCell.font = [NSFont systemFontOfSize:13];
    } else if ([self isGroupRow:row]) {
        textCell.textColor = [NSColor colorWithCGColor:CGColorCreateGenericRGB(0, 0, 128, 1.0)];
        textCell.font = [NSFont boldSystemFontOfSize:13];
    } else {
        textCell.textColor = [NSColor blackColor];
        textCell.font = [NSFont systemFontOfSize:13];
    }
}

- (BOOL) isGroupRow:(NSInteger)row {
    if ([self noMatch]) {
        return NO;
    }
    ResultsItem *item = resultsItems[row];
    return item.groupLevel == 0;
}



@end
