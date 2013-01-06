//
//  Recipe.h
//  MyCookbook
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recipe : NSObject <NSCoding>

@property NSString *title, *description;
@property NSMutableArray *manual;
@property NSMutableSet *category;

@end
