//
//  Author+Create.m
//  HabraReader Prototype
//
//  Created by Sergey on 04.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Author+Create.h"

@implementation Author (Create)

- (NSString *)description {
    return self.nickName;
}

+ (Author *)authorWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Author *author = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Author"];
    request.predicate = [NSPredicate predicateWithFormat:@"nickName = %@", name];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nickName" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *authors = [context executeFetchRequest:request error:&error];
    
    if (!authors || ([authors count] > 1)) {
        // TODO: handle error
    } else if (![authors count]) {
        author = [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:context];
        author.nickName = name;
    } else {
        author = [authors lastObject];
    }
    
    return author;
}

@end
