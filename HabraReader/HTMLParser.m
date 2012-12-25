//
//  HTMLParser.m
//  HabraReader
//
//  Created by Sergey Starukhin on 20.11.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HTMLParser.h"

@interface HTMLParser () {
    BOOL isAbortParsing;
}

@property (nonatomic, strong) NSScanner *scanner;
@property (nonatomic, strong) NSSet *ignoreTags; // set of ignored tags: script, ...
@property (nonatomic, strong) NSMutableCharacterSet *beginTag;
@property (nonatomic, strong) NSMutableCharacterSet *closeTag;

@end

@implementation HTMLParser

- (NSSet *)ignoreTags {
    if (! _ignoreTags) {
        _ignoreTags = [NSSet setWithObjects:@"script", @"head", nil];
    }
    return _ignoreTags;
}

- (NSMutableCharacterSet *)beginTag {
    if (!_beginTag) {
        _beginTag = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [_beginTag addCharactersInString:@"<"];
    }
    return _beginTag;
}

- (NSMutableCharacterSet *)closeTag {
    if (!_closeTag) {
        _closeTag = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [_closeTag addCharactersInString:@"/"];
    }
    return _closeTag;
}
/*
- (id)initWithContentsOfURL:(NSURL *)url {
    return nil;
}
*/
- (id)initWithData:(NSData *)data {
    NSString *stringForParsing = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [self initWithString:stringForParsing];
}
/*
- (id)initWithStream:(NSInputStream *)stream {
    return nil;
}
*/
// Main initializer
- (id)initWithString:(NSString *)string {
    self.scanner = [[NSScanner alloc] initWithString:string];
    return self;
}

- (BOOL)parse {
    isAbortParsing = NO;
    BOOL isParseWithoutError = YES;
    NSString *tagName;
    NSString *currentElement;
    if ([self.delegate respondsToSelector:@selector(parserDidStartDocument:)]) {
        [self.delegate parserDidStartDocument:self];
    }
    while (!([self.scanner isAtEnd] || isAbortParsing)) {
        currentElement = [NSString string];
        [self.scanner scanUpToString:@"<" intoString:&currentElement];
        if (![currentElement isEqualToString:@""]) {
            //NSLog(@"found characters:%@",currentElement);
            [self.delegate parser:self foundCharacters:currentElement];// found characters: currentElement
        }
        //self.scanner.scanLocation = self.scanner.scanLocation + 1;
        self.scanner.charactersToBeSkipped = self.beginTag; // иногда в currentElement поопадает "<" поэтому скипаем его
        [self.scanner scanUpToString:@">" intoString:&currentElement];
        self.scanner.charactersToBeSkipped = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        self.scanner.scanLocation = self.scanner.scanLocation + 1;
        NSScanner *tagScanner = [NSScanner scannerWithString:currentElement];
        //NSLog(@"current element:%@",currentElement);
        [tagScanner scanUpToString:@" " intoString:&tagName];
        //NSLog(@"tag name:%@",tagName);
        if ([tagName hasPrefix:@"!"]) continue; // skip comments
        if ([tagName hasPrefix:@"/"]) {
            // if close tag
            [self.delegate parser:self didEndElement:[tagName substringFromIndex:1] namespaceURI:nil qualifiedName:nil];
        } else {
            // if open tag
            if ([self.ignoreTags containsObject:tagName]) {
                [self.scanner scanUpToString:[NSString stringWithFormat:@"</%@>",tagName] intoString:NULL];
                self.scanner.scanLocation = self.scanner.scanLocation + tagName.length + 3;
            } else {
                NSString *attributeKey;
                NSString *attributeValue;
                NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
                tagScanner.charactersToBeSkipped = self.closeTag; // add "/" to ignore characters set for tagScanner for tags <br />
                while (tagScanner.isAtEnd == NO) {
                    [tagScanner scanUpToString:@"=\"" intoString:&attributeKey];
                    //NSLog(@"attribute key:%@",attributeKey);
                    //NSAssert(!tagScanner.isAtEnd, @"Сканнер закончился! Нашли аттрибут:%@", attributeKey);
                    if (tagScanner.isAtEnd) {
                        // FIXME: what if more than one boolean attribute
                        // found attribute without value (boolean)
                        attributeValue = @"true";
                    } else {
                        tagScanner.scanLocation = tagScanner.scanLocation + 2;
                        [tagScanner scanUpToString:@"\"" intoString:&attributeValue];
                        //NSLog(@"attribute value:%@",attributeValue);
                        tagScanner.scanLocation = tagScanner.scanLocation + 1;
                    }
                    [attributes setObject:attributeValue forKey:attributeKey];
                }
                //NSLog(@"attributes:%@",attributes);
                [self.delegate parser:self didStartElement:tagName namespaceURI:nil qualifiedName:nil attributes:attributes];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(parserDidEndDocument:)]) {
        [self.delegate parserDidEndDocument:self];
    }
    return isParseWithoutError;
}

- (void)abortParsing {
    isAbortParsing = YES;
}

- (NSError *)parserError {
    return nil;
}

@end
