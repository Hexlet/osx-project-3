//
//  NSRegularExpression+Ext.h
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (Ext)

/*
Returns array of matches, each element is array of ranges.
First element is the range of the whole match, other elements are ranges of groups of this match.
 */
- (NSArray *) allMatchesWithGroups:(NSString *)source;

@end
