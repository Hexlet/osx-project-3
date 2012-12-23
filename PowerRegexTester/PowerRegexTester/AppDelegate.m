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

@interface AppDelegate()
@property (nonatomic, readonly) ResultsTable *results;
@end

@implementation AppDelegate

@synthesize results = _results;
- (ResultsTable *)results {
    if (!_results) {
        _results = [[ResultsTable alloc] init];
    }
    return _results;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.resultsTableView.dataSource = self.results;
    self.resultsTableView.delegate = self.results;
}

- (IBAction)clearClick:(NSButton *)sender {
    self.sourceView.string = @"";
}

- (IBAction)loadClick:(NSButton *)sender {
    NSURL *url = [NSURL URLWithString:self.url.stringValue];
    if (url) {
        [self loadStringFromUrl:url];
    }
}

- (IBAction)fileClick:(NSButton *)sender {
    NSURL *fileUrl = [[[FileDialog alloc] init] openFile];
    if (fileUrl) {
        [self loadStringFromUrl:fileUrl];
        self.url.stringValue = fileUrl.absoluteString;
    }
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
        [self handleError:error];
        return;
    }
    self.sourceView.string = urlContents;
}

- (IBAction)applyClick:(NSButton *)sender {
    NSString *pattern = self.pattern.stringValue;
    NSError *error;
    NSRegularExpressionOptions options = [self.options regexOptions];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:options
                                                                             error:&error];
    if (error) {
        [self handleError:error];
        return;
    }
    
    NSString *sourceString = self.sourceView.string;
    NSArray *matches = [regex allMatchesWithGroups:sourceString];
    [self.results setSourceString:self.sourceView.string andRangesOfMatches:matches];
    [self.resultsTableView reloadData];
}

- (void) handleError:(NSError *)error {
    NSLog(@"ERROR: %@", error.description);
}

@end
