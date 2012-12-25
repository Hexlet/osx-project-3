//
//  AppDelegate.m
//  PowerRegexTester
//
//  Created by Igor on 18/11/2012.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import "AppDelegate.h"
#import "FileDialog.h"
#import "NSRegularExpression+Ext.h"
#import "ResultsTable.h"
#import "ResultsItem.h"

@interface AppDelegate()
@property (nonatomic, readonly) ResultsTable *results;
@end

@implementation AppDelegate

- (void) applicationWillFinishLaunching:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSelectionChanged:) name:kSelectedItemChanged object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) onSelectionChanged:(NSNotification *)notification {
    if (! [notification.object isKindOfClass:ResultsItem.class]) {
        return;
    }
    ResultsItem *selectedItem = (ResultsItem *)notification.object;
    NSRange selectedRange = selectedItem.rangeInSource;
    self.sourceView.selectedRange = selectedRange;
}

- (ResultsTable *)results {
    return (ResultsTable *)self.resultsTableView.dataSource;
}

- (IBAction)clearClick:(id)sender {
    self.sourceView.string = @"";
    [self hideErrorText];
}

- (IBAction)loadClick:(id)sender {
    NSString *urlString = self.url.stringValue;
    if (urlString == nil || [urlString isEqualToString:@""]) { return; }
    NSURL *url = [NSURL URLWithString:urlString];
    if (url) {
        [self loadStringFromUrl:url];
    }
}

- (IBAction)fileClick:(id)sender {
    NSURL *fileUrl = [[[FileDialog alloc] init] openFile];
    if (fileUrl) {
        [self loadStringFromUrl:fileUrl];
        self.url.stringValue = fileUrl.absoluteString;
    }
    [self hideErrorText];
}

- (void) loadStringFromUrl:(NSURL *)url {
    [self.loadProgress setHidden:NO];
    [self.loadProgress startAnimation:self];
    NSError *error;
    NSString *urlContents = [NSString stringWithContentsOfURL:url
                                                     encoding:NSASCIIStringEncoding
                                                        error:&error];
    [self.loadProgress stopAnimation:self];
    [self.loadProgress setHidden:YES];
    if (error) {
        [self showError:error];
        return;
    }
    self.sourceView.string = urlContents;
    [self hideErrorText];
}

- (IBAction)applyClick:(id)sender {
    NSString *pattern = self.pattern.stringValue;
    if (pattern == nil || [pattern isEqualToString:@""]) { return; }
    NSError *error;
    NSRegularExpressionOptions options = [self.options regexOptions];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:options
                                                                             error:&error];
    if (error) {
        [self showError:error];
        return;
    }
    NSString *sourceString = self.sourceView.string;
    NSArray *matches = [regex allMatchesWithGroups:sourceString];
    [self.results setSourceString:self.sourceView.string andRangesOfMatches:matches];
    [self.resultsTableView reloadData];
    [self hideErrorText];
    

}

- (void) showError:(NSError *)error {
    self.statusText.stringValue = error.localizedDescription;
}

- (void) hideErrorText {
    self.statusText.stringValue = @"";
}

@end
