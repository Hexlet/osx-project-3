//
//  Document.h
//  VBoxCamp
//
//  Created by Dmitriy Zavorokhin on 12/26/12.
//  Copyright (c) 2012 goodman116@gmail.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument {
     NSArray *volumes;
}

@property IBOutlet NSTableView *volumesTableView;

@end
