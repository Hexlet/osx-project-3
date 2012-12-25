//
//  Hub+Create.h
//  HabraReader Prototype
//
//  Created by Sergey on 04.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Hub.h"

@interface Hub (Create)

+ (Hub *)hubWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
