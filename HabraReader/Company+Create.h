//
//  Company+Create.h
//  HabraReader Prototype
//
//  Created by Sergey on 04.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Company.h"

@interface Company (Create)

+ (Company *)companyWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
