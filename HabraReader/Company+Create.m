//
//  Company+Create.m
//  HabraReader Prototype
//
//  Created by Sergey on 04.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Company+Create.h"

@implementation Company (Create)

+ (Company *)companyWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Company *company = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *companies = [context executeFetchRequest:request error:&error];
    
    if (!companies || ([companies count] > 1)) {
        // TODO: handle error
    } else if (![companies count]) {
        company = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
        company.name = name;
    } else {
        company = [companies lastObject];
    }
    
    return company;
}

@end
