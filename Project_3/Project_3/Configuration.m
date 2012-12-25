//
//  Configuration.m
//  Project_3
//
//  Created by Admin on 12/23/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration

-(id)init{
    self = [super init];
    if(self){
        self.popultaionSize = 3600;
        self.dnaLen = 160;
        self.mutRate = 18;
    }
    return self;
}

@end
