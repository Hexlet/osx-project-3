//
//  NSMutableString+RemoveTag.m
//  HabraReader
//
//  Created by Sergey Starukhin on 06.09.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "NSMutableString+RemoveTag.h"
#import "NSString+Tags.h"

@implementation NSMutableString (RemoveTag)
/*
- (void)removeTag:(NSString *)tag {
    NSString *openTag = [NSString stringWithFormat:@"<%@",tag];
    NSString *closeTag = [NSString stringWithFormat:@"</%@>",tag];
    __block BOOL tagNotFound = YES;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]-1) options:NSStringEnumerationByLines usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
        if (tagNotFound) {
            NSRange found = [substring rangeOfString:openTag];
            if (found.location != NSNotFound) {
                tagNotFound = NO;
                [self deleteCharactersInRange:substringRange];
            }
        } else {
            NSRange found = [substring rangeOfString:closeTag];
            if (found.location != NSNotFound) {
                tagNotFound = YES;
            }
            [self deleteCharactersInRange:substringRange];
        }
    }];
}
*/
- (void)removeTag:(NSString *)tag {
    [self deleteCharactersInRange:[self rangeForTag:tag withClass:nil]];
}

@end
