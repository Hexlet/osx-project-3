//
//  ResultsTableViewController.h
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSelectedItemChanged;

@interface ResultsTable : NSObject <NSTableViewDataSource, NSTableViewDelegate>

- (void) setSourceString:(NSString *)string
      andRangesOfMatches:(NSArray *)matches;

@end
