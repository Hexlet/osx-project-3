//
//  Author+Create.h
//  HabraReader Prototype
//
//  Created by Sergey on 04.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Author.h"

@interface Author (Create)

- (NSString *)description;

+ (Author *)authorWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
