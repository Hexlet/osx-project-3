//
//  OptionsMatrix.m
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import "OptionsMatrix.h"

@implementation OptionsMatrix

- (NSRegularExpressionOptions) regexOptions {
    NSRegularExpressionOptions options = 0;
    for (NSButtonCell *cell in self.cells) {
        if (cell.state != NSOnState) {
            continue;
        }
        NSString *cellIdentifier = cell.identifier;
        if ([cellIdentifier isEqualToString:@"CaseInsensitive"]) {
            options |= NSRegularExpressionCaseInsensitive;
        } else if ([cellIdentifier isEqualToString:@"DotMatchesLineSeparators"]) {
            options |= NSRegularExpressionDotMatchesLineSeparators;
        } else if ([cellIdentifier isEqualToString:@"AnchorsMatchLines"]) {
            options |= NSRegularExpressionAnchorsMatchLines;
        } else if ([cellIdentifier isEqualToString:@"IgnoreMetacharacters"]) {
            options |= NSRegularExpressionIgnoreMetacharacters;
        } else if ([cellIdentifier isEqualToString:@"UseUnicodeWordBounds"]) {
            options |= NSRegularExpressionUseUnicodeWordBoundaries;
        } else if ([cellIdentifier isEqualToString:@"UseUnixLineSeparators"]) {
            options |= NSRegularExpressionUseUnixLineSeparators;
        } else if ([cellIdentifier isEqualToString:@"CommentsAndWhitespace"]) {
            options |= NSRegularExpressionAllowCommentsAndWhitespace;
        }
    }
    return options;
}


@end
