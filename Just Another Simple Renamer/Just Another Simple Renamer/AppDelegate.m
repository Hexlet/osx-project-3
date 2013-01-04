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
    }
    [_SourceTableView reloadData];
}

- (IBAction)addFolder:(id)sender {
    NSOpenPanel* openDialog = [NSOpenPanel openPanel];
    NSError *error = nil;
    NSArray *URLList;
    [openDialog setCanChooseFiles:NO];
    [openDialog setCanChooseDirectories:YES];
    if ([openDialog runModal] == NSOKButton) {
        //Получаем список URL'ов
        URLList = [[NSFileManager defaultManager]
          contentsOfDirectoryAtURL:[[openDialog URLs]objectAtIndex:0]
          includingPropertiesForKeys:[NSArray array]
          options:(NSDirectoryEnumerationSkipsHiddenFiles)
          error:&error];
        //Добавляем только файлы, папки не берем
        for (NSURL *fileURL in URLList) {
            NSNumber *isDirectory = nil;
            [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
            if (![isDirectory boolValue]) {
                [SourceFilesArray addObject:fileURL];
            }
        }
    }
    [_SourceTableView reloadData];
}

- (IBAction)clearList:(id)sender {
    [SourceFilesArray removeAllObjects];
    [_SourceTableView reloadData];
}

- (IBAction)goRename:(id)sender {
    if ([SourceFilesArray count] >0) {
        [ResultFileNames removeAllObjects];     //Очищаем массив каждый раз, т.к. таблица целевых имен должна динамически реагировать на изменения в полях ввода
        for (NSInteger i = [_CounterStartFrom integerValue]; [ResultFileNames count] < [SourceFilesArray count]; i++) {
            NSString *str = [NSString stringWithString:[_PrefixName stringValue]];
            str = [str stringByAppendingString:[NSString stringWithFormat:[_CounterMask stringValue], i]];
            [ResultFileNames addObject:str];
        }
    }
    
    [_ResultTableView reloadData];
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
        NSString *v = [[[SourceFilesArray objectAtIndex:row] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
