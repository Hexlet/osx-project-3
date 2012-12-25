//
//  AppDelegate.m
//  PasteBoard
//
//  Created by Yuriy Ostapyuk on 11/19/12.
//  Copyright (c) 2012 Yuriy Ostapyuk. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

NSInteger previousChangeCount = 0;

// limitation for our paste board rows
NSInteger pasteBoardSize = 50;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // initializing array for paste board elements storing
    pasteboardElements = [[NSMutableArray alloc] init];
    
    // pasteboard instance
    pasteboard = [NSPasteboard generalPasteboard];
    
    // make first initial pull from paste board to take first value
    [self pullPasteboard:nil];
    
    // enable timer to check paste board for new values every 1.5 seconds
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(pullPasteboard:) userInfo:nil repeats:YES];
}

- (void)pullPasteboard:(NSTimer *)timer {

    // current count of pasteboard receivers
    NSInteger currentChangeCount = [pasteboard changeCount];
    
    // if current count of paste board receivers didn't change from previous time there is nothing to do
    if (currentChangeCount == previousChangeCount)
        return;
    
    // searching for string values in paste board
    NSArray *classes = [[NSArray alloc] initWithObjects:[NSString class], nil];
    NSDictionary *options = [NSDictionary dictionary];
    BOOL ok = [pasteboard canReadObjectForClasses:classes options:options];
    
    // if receiver contains any item as instance of NSString we read it
    if (ok) {
        for (NSString *str in [pasteboard readObjectsForClasses:classes options:options]) {
            // if current element already presented at the first table view row
            if([pasteboardElements indexOfObject:str] == 0) continue;
            
            // and insert as first element in our array for storing
            [pasteboardElements insertObject:str atIndex:0];
            
            // here I make some limitation, if count of elements in our paste board
            // will exceed limit I will delete each the oldest (last) elements
            if ([pasteboardElements count] > pasteBoardSize) {
                [pasteboardElements removeObjectAtIndex:pasteBoardSize];
            }
        }
        
        // update table view with fresh data
        [_tableView reloadData];
    }
    
    // update counter
    previousChangeCount = currentChangeCount;
}

- (void)awakeFromNib {
    // enable double click action for table cell
    [_tableView setTarget:self];
    [_tableView setDoubleAction:@selector(doubleClick:)];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView*) tv {
    // number of rows for current table view
    return (NSInteger)[pasteboardElements count];
}

-(id)tableView:(NSTableView*) tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // filling table view with data from paste borad
    NSString *c = nil;
    if ([pasteboardElements count] > row) {
        c = [pasteboardElements objectAtIndex:row];
    }
    return c;
}

- (void)doubleClick:(id)object {
    NSInteger row = [_tableView selectedRow];
    if (row == -1 || row >= [pasteboardElements count]) return;
    
    // here we take value from doubleclicked row and copy it to system pasteboard
    NSObject *selectedElement = [pasteboardElements objectAtIndex:row];

    [pasteboard clearContents];
    
    NSArray *copiedObjects = [NSArray arrayWithObject:selectedElement];
    
    [pasteboard writeObjects:copiedObjects];
    
}

@end
