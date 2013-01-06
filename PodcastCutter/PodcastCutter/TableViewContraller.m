//
//  TableViewContraller.m
//  PodcastCutter
//
//  Created by Arthur Belous on 05.01.13.
//  Copyright (c) 2013 Arthur Belous. All rights reserved.
//

#import "TableViewContraller.h"
#import "CueParser.h"
#import "Mp3Arrays.h"

@implementation TableViewContraller

-(id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
    Mp3Arrays * mp = [[Mp3Arrays alloc] init];
    tableArray = [[NSMutableArray alloc]init];
}

-(NSInteger) numberOfRowsInTableView:(NSTableView*) tableView
{
    return [mp ]
}


@end
