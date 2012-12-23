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

#pragma mark == NSTableViewDataSource implementation ==
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [resultsItems count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return resultsItems[row];
}

#pragma mark == NSTableViewDelegate implementation ==
- (BOOL) tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    ResultsItem *item = resultsItems[row];
    return item.groupLevel == 0;
}

@end
