//
//  Recipe.m
//  MyCookbook
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

-(id)init {
    if (self = [super init]) {
        _title = @"New recipe";
        _description = @"Add description";
        _manual = [NSMutableArray array];
        _category = [[NSMutableSet alloc] initWithObjects:@"All recipes", nil];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_description forKey:@"description"];
    [aCoder encodeObject:_manual forKey:@"manual"];
    [aCoder encodeObject:_category forKey:@"category"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _description = [aDecoder decodeObjectForKey:@"description"];
        _manual = [aDecoder decodeObjectForKey:@"manual"];
        _category = [aDecoder decodeObjectForKey:@"category"];

    }
    return self;
}


@end
