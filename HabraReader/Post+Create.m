//
//  Post+Create.m
//  HabraReader Prototype
//
//  Created by Sergey on 04.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Post+Create.h"

@implementation Post (Create)

+ (Post *)postWithId:(NSUInteger)postId inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Post *post = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqId = %d", postId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"uniqId" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *posts = [context executeFetchRequest:request error:&error];
    
    if (!posts || ([posts count] > 1)) {
        // TODO: handle error
    } else if (![posts count]) {
        post = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self) inManagedObjectContext:context];
        post.uniqId = postId;
    } else {
        post = [posts lastObject];
    }
    
    return post;
}

@end
