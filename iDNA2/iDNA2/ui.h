//
//  ui.h
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 05.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ui : NSObject

+ (void)alertDialogWithTitle:(NSString *)title andText:(NSString *)text;

+ (BOOL)openFileDialogAndReadContent:(NSString **)fileContent;

@end
