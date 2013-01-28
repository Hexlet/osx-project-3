//
//  ui.m
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 05.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ui.h"

@implementation ui

+ (void)alertDialogWithTitle:(NSString *)title andText:(NSString *)text {
    NSAlert * alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:title];
    [alert setInformativeText:text];
    [alert setAlertStyle:NSCriticalAlertStyle];
    [alert runModal];
}

+ (BOOL)openFileDialogAndReadContent:(NSString *__autoreleasing *)fileContent {
    // создаем объект диалога
    NSOpenPanel * openFileDialog = [NSOpenPanel openPanel];
    
    // настраиваем его на выбор одного файла
    [openFileDialog setCanChooseFiles:YES];
    [openFileDialog setCanChooseDirectories:NO];
    [openFileDialog setAllowsMultipleSelection:NO];
    [openFileDialog setResolvesAliases:YES];
    
    // открываем диалог, ожидаем завершения его работы
    if ([openFileDialog runModal] == NSOKButton) {
        // диалог возвращает массив со ссылками на выбранные файлы
        NSArray * urls = [openFileDialog URLs];
        // проверяем, действительно ли в массиве есть ссылка на один файл
        if ([urls count] == 1) {
            NSURL * url = [urls objectAtIndex:0];
            NSStringEncoding enc;
            NSError * err = nil;
            // читаем содержимое файла
            * fileContent = [NSString stringWithContentsOfURL:url
                                                 usedEncoding:&enc 
                                                        error:&err];
            if (err != nil) {
                NSLog(@"There is the following problem with opening file \"%@\":\n%@", url, err);
            } else {
                return YES;
            }
        }
    }
    return NO;
}

@end
