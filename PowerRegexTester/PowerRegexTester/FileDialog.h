//
//  FileDialog.h
//  PowerRegexTester
//
//  Created by Igor on 12/22/12.
//  Copyright (c) 2012 Igor Redchuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDialog : NSObject <NSOpenSavePanelDelegate>

- (NSURL *) openFile;

@end
