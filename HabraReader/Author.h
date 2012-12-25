//
//  Author.h
//  HabraReader
//
//  Created by Sergey on 09.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Post;

@interface Author : NSManagedObject

@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *posts;
@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
