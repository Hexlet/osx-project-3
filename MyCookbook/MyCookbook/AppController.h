//
//  AppController.h
//  MyCookbook
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recipe.h"


@interface AppController : NSObject {
    Recipe *newRecipe;
}

-(IBAction)addRecipeDescription:(id)sender;

@end
