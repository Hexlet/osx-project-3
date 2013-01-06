//
//  TableViewContraller.h
//  PodcastCutter
//
//  Created by Arthur Belous on 05.01.13.
//  Copyright (c) 2013 Arthur Belous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewContraller : NSObject
{
    @private
    IBOutlet NSTableView *tableView;
    NSMutableArray * tableArray; 
}
-(NSInteger) numberOfRowsInTableView:(NSTableView*) tableView;

@end
