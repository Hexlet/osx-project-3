//
//  Message+Count.m
//  HabraReader
//
//  Created by Sergey Starukhin on 22.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Message+Count.h"

@implementation Message (Count)

- (NSUInteger)countOfComments {
    NSUInteger result = [self.comments count];
    for (Message *reply in self.comments) {
        result += [reply countOfComments];
    }
    return result;
}

- (NSComparisonResult)compare:(Message *)other {
    return [self.publicationDate compare:other.publicationDate];
}

@end
