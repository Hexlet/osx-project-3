//
//  HRCommentsParser.m
//  HabraReader
//
//  Created by Sergey Starukhin on 18.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRCommentsParser.h"
#import "HTMLParser.h"
#import "Post+Create.h"
#import "Author+Create.h"
#import "Comment.h"

enum HRParsingState {
    Stop = 0,
    Parsing = 1,
    CommentBegin = 2,
    WaitForAuthorAndDate = 3,
    WaitContent= 4
};

@interface HRCommentsParser () <HTMLParserDelegate> {
    NSUInteger state;
    NSUInteger currentLevel;
    NSUInteger commentLevel;
    NSMutableString *currentElement;
    Comment *currentComment;
    Comment *lastComment;
}

@property (nonatomic, strong) Post *postForComments;

@end

@implementation HRCommentsParser

+ (void)parseCommentsForPost:(Post *)post fromString:(NSString *)comments {
    HRCommentsParser *parser = [[HRCommentsParser alloc] init];
    parser.postForComments = post;
    HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:comments];
    htmlParser.delegate = parser;
    [htmlParser parse];
}

#pragma mark - HTMLParserDelegate protocol implementation

// документ начал парситься
- (void)parserDidStartDocument:(HTMLParser *)parser {
    //    NSLog(@"%s",__PRETTY_FUNCTION__);
    state = Stop;
}

// парсинг окончен
- (void)parserDidEndDocument:(HTMLParser *)parser {
    //    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// если произошла ошибка парсинга
-(void) parser:(HTMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //NSLog(@"%s error %@ at string:%d",__PRETTY_FUNCTION__,[parseError localizedDescription],[parser lineNumber]);
}

// встретили новый элемент
- (void)parser:(HTMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    switch (state) {
        case Stop:
            // ждем начала элемента <ul>
            if ([elementName isEqual:@"ul"]) {
                state = Parsing;
                // Создать текущий элемент???
            }
            break;
        case Parsing:
            if ([elementName isEqualToString:@"li"]) {
                // comment is begin check class
                currentComment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.postForComments.managedObjectContext];
                NSMutableString *commentClass = [[attributeDict objectForKey:@"class"] mutableCopy];
                if (commentClass) [commentClass deleteCharactersInRange:NSMakeRange(0, 1)];
                commentLevel = [commentClass integerValue];
                state = CommentBegin;
            }
            break;
        case CommentBegin:
            if ([elementName isEqualToString:@"div"]) {
                if ([[attributeDict objectForKey:@"class"] isEqualToString:@"m"]) {
                    currentElement = [NSMutableString string];
                    state = WaitForAuthorAndDate;
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)parser:(HTMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    switch (state) {
        case Parsing:
            if ([elementName isEqualToString:@"ul"]) {
                state = Stop;
            }
            break;
        case WaitForAuthorAndDate:
            if ([elementName isEqualToString:@"div"]) {
                NSArray *authorAndDate = [currentElement componentsSeparatedByString:@","];
                //NSLog(@"Author nickName: %@",[authorAndDate objectAtIndex:0]);
                currentComment.author = [Author authorWithName:[authorAndDate objectAtIndex:0] inManagedObjectContext:self.postForComments.managedObjectContext];
                //NSLog(@"publicationDate(string): %@",[authorAndDate objectAtIndex:1]);
                NSString *dateString = [[authorAndDate objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                //                NSLog(@"date string:%@",dateString);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                NSArray *dateComponents = [dateString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *day = [dateComponents objectAtIndex:0];
                //NSString *month = [dateComponents objectAtIndex:1];
                //NSString *year = [dateComponents objectAtIndex:2];
                NSString *time = [dateComponents lastObject];
                NSTimeInterval timeInterval = 0;
                switch (dateComponents.count) {
                    case 3:
                        [formatter setDateFormat:@"dd MMMM yyyy"];
                        if ([day isEqualToString:@"вчера"]) {
                            timeInterval = -86400;
                        }
                        dateString = [NSString stringWithFormat:@"%@ в %@",[formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]],time];
                        break;
                        
                    case 4:
                        [formatter setDateFormat:@"yyyy"];
                        dateString = [NSString stringWithFormat:@"%@ %@ %@ в %@", day, [dateComponents objectAtIndex:1], [formatter stringFromDate:[NSDate date]], time];
                        break;
                        
                    default:
                        break;
                }
                //                NSLog(@"date:%@",dateString);
                [formatter setDateFormat:@"dd MMMM yyyy 'в' HH:mm"];
                NSDate *date = [formatter dateFromString:dateString];
                //                NSLog(@"publicationDate: %@", date);
                currentComment.publicationDate = date;
                currentElement = [NSMutableString string];
                state = WaitContent;
            }
            break;
        case WaitContent:
            if ([elementName isEqualToString:@"li"]) {
                currentComment.content = [currentElement copy];
                // comment ending
                if (0 == commentLevel) {
                    [self.postForComments addCommentsObject:currentComment];
                    currentLevel = 0;
                } else {
                    if (commentLevel > currentLevel) {
                        currentLevel++;
                        [lastComment addCommentsObject:currentComment];
                    } else {
                        if (commentLevel < currentLevel) {
                            do {
                                lastComment = lastComment.replyTo;
                                currentLevel--;
                            } while (commentLevel < currentLevel);
                        }
                        [lastComment.replyTo addCommentsObject:currentComment];
                    }
                }
                lastComment = currentComment;
                state = Parsing;
            }
            break;
            
        default:
            //if ([elementName isEqual:@"li"]) {
                //state = Stop;
            //}
            break;
    }
    //NSLog(@"end element:%@\n",elementName);
}

- (void)parser:(HTMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"%s characters:%@",__PRETTY_FUNCTION__,string);
    switch (state) {
        case WaitContent:
        case WaitForAuthorAndDate:
            [currentElement appendString:string];
            break;
            
        default:
            break;
    }
}

@end
