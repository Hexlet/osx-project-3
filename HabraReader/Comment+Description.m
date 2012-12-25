//
//  Comment+Description.m
//  HabraReader
//
//  Created by Sergey Starukhin on 22.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "Comment+Description.h"

@implementation Comment (Description)

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, %@\n\n%@", self.author, self.publicationDate, self.content];
}

@end
