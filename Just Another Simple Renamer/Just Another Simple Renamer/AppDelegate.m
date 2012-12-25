//
//  AppDelegate.m
//  Just Another Simple Renamer
//
//  Created by Администратор on 12/20/12.
//  Copyright (c) 2012 Nope. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    ResultFileNames = [NSMutableArray array];
    SourceFilesArray = [NSMutableArray array];
    // Insert code here to initialize your application
}

- (IBAction)addFiles:(id)sender {
    NSOpenPanel* openDialog = [NSOpenPanel openPanel];
    [openDialog setAllowsMultipleSelection:YES];
    if ([openDialog runModal] == NSOKButton) {
        [SourceFilesArray addObjectsFromArray:[openDialog URLs]];
        NSLog(@"%@", SourceFilesArray);
    }
    [_SourceTableView reloadData];
}

- (IBAction)addFolder:(id)sender {
    NSOpenPanel* openDialog = [NSOpenPanel openPanel];
    [openDialog setCanChooseFiles:NO];
    [openDialog setCanChooseDirectories:YES];
    if ([openDialog runModal] == NSOKButton) {
        [SourceFilesArray addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtURL:[[openDialog URLs]objectAtIndex:0] includingPropertiesForKeys:nil options:Nil error:nil]];
        NSLog(@"%@", SourceFilesArray);
    }
    [_SourceTableView reloadData];
}

- (IBAction)clearList:(id)sender {
    [SourceFilesArray removeAllObjects];
    [_SourceTableView reloadData];
}

- (IBAction)goRename:(id)sender {
}

-(NSInteger)numberOfRowsInTableView:(NSTableView*) SomeTableView {
    if (SomeTableView == _SourceTableView) {
        return [SourceFilesArray count];
    }
    else if (SomeTableView == _ResultTableView) {
        return [ResultFileNames count];
    }
    else {
        NSLog(@"numberOfRowsInTableView returning 0");
        return 0;
    }
}

-(id)tableView:(NSTableView*) SomeTableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (SomeTableView == _SourceTableView) {
        NSString *v = [SourceFilesArray objectAtIndex:row];
        return v;
    }
    else if (SomeTableView == _ResultTableView) {
        return [ResultFileNames objectAtIndex:row];
    }
    else {
        NSLog(@"objectValueForTableColumn returning 0");
        return 0;
    }
}

@end
