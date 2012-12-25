//
//  NSString+Tags.m
//  HabraReader
//
//  Created by Sergey on 14.11.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "NSString+Tags.h"

@implementation NSString (Tags)

- (NSRange)rangeForTag:(NSString *)tag withClass:(NSString *)classOfTag {
    NSRange result;
    NSUInteger foundTags = 0;
    NSString *closeTag = [NSString stringWithFormat:@"/%@",tag];
    NSString *currentTag;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    while (!foundTags) {
        [scanner scanUpToString:@"<" intoString:NULL];
        if (scanner.isAtEnd) return NSMakeRange(NSNotFound, 0);
        result.location = scanner.scanLocation;
        scanner.scanLocation = scanner.scanLocation + 1;
        [scanner scanUpToString:@">" intoString:&currentTag];
        if ([currentTag hasPrefix:tag]) {
            if (classOfTag) {
                if ([[[currentTag attributes] objectForKey:@"class"] isEqualToString:classOfTag]) foundTags++;
            } else {
                foundTags++;
            }
        }
    }
    do {
        [scanner scanUpToString:@"<" intoString:NULL];
        NSAssert(!scanner.isAtEnd, @"Сканнер закончился! Искали закрывающий тег:%@ с классом:%@ в строке:%@", tag, classOfTag, self);
        scanner.scanLocation = scanner.scanLocation + 1;
        [scanner scanUpToString:@">" intoString:&currentTag];
        if ([currentTag hasPrefix:closeTag]) {
            foundTags--;
        } else if ([currentTag hasPrefix:tag]) {
            foundTags++;
        }
    } while (foundTags);
    result.length = scanner.scanLocation - result.location + 2;
    return result;
}

- (NSDictionary *)attributes {
    NSString *attributeKey;
    NSString *attributeValue;
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanUpToString:@" " intoString:NULL]; // пропускаем имя тега
    while (scanner.isAtEnd == NO) {
        [scanner scanUpToString:@"=\"" intoString:&attributeKey];
        scanner.scanLocation = scanner.scanLocation + 2;
        [scanner scanUpToString:@"\"" intoString:&attributeValue];
        scanner.scanLocation = scanner.scanLocation + 1;
        [result setObject:attributeValue forKey:attributeKey];
    }
    NSLog(@"%s:%@",__PRETTY_FUNCTION__,result);
    return result;
}

@end
