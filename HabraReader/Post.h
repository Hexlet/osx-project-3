//
//  Post.h
//  HabraReader
//
//  Created by Sergey Starukhin on 15.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Message.h"

@class Author, GenericHub, Tag;

@interface Post : Message

@property (nonatomic) int32_t countOfComments;
@property (nonatomic) BOOL inFavorites;
@property (nonatomic) BOOL isRead;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) int32_t uniqId;
@property (nonatomic) int32_t rating;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) Author *author;
@property (nonatomic, retain) NSSet *hubs;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addHubsObject:(GenericHub *)value;
- (void)removeHubsObject:(GenericHub *)value;
- (void)addHubs:(NSSet *)values;
- (void)removeHubs:(NSSet *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
