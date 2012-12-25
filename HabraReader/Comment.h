//
//  Comment.h
//  HabraReader
//
//  Created by Sergey on 09.10.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Message.h"

@class Author, Message;

@interface Comment : Message

@property (nonatomic) BOOL isRead;
@property (nonatomic, retain) Author *author;
@property (nonatomic, retain) Message *replyTo;

@end
