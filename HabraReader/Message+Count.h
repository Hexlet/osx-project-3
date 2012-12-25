//
//  Message+Count.h
//  HabraReader
//
//  Created by Sergey Starukhin on 22.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Message.h"

@interface Message (Count)

- (NSUInteger)countOfComments;
- (NSComparisonResult)compare:(Message *)other;

@end
