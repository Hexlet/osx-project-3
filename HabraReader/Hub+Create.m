//
//  Hub+Create.m
//  HabraReader Prototype
//
//  Created by Sergey on 04.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Hub+Create.h"

@implementation Hub (Create)

+ (Hub *)hubWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Hub *hub = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *hubs = [context executeFetchRequest:request error:&error];
    
    if (!hubs || ([hubs count] > 1)) {
        // TODO: handle error
    } else if (![hubs count]) {
        hub = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
        hub.name = name;
    } else {
        hub = [hubs lastObject];
    }
    
    return hub;
}

@end
