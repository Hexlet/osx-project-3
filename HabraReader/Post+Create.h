//
//  Post+Create.h
//  HabraReader Prototype
//
//  Created by Sergey on 04.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Post.h"

@interface Post (Create)

+ (Post *)postWithId:(NSUInteger)postId inManagedObjectContext:(NSManagedObjectContext *)context;

@end
