//
//  Document.h
//  MyCookbook
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Recipe.h"


@interface Document : NSDocument {
    NSMutableArray *recipes;
    NSMutableSet *allCategories;
    IBOutlet NSTableView *table;
    
}

-(void)insertObject:(Recipe *)r inRecipesAtIndex:(NSInteger)index;
-(void)removeObjectFromRecipesAtIndex:(NSInteger)index;


-(void)setRecipes:(NSMutableArray *)r;


@end
