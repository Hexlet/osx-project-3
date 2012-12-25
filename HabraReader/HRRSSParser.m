//
//  HRRSSParser.m
//  HabraReader
//
//  Created by Sergey on 11.11.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRRSSParser.h"
#import "NSMutableString+RemoveTag.h"
#import "Post+Create.h"

enum StateOfParser {
    Wait = 0,
    FoundItem = 1,
    FoundLink = 2,
    FoundDescription = 3
};

@interface HRRSSParser () <NSXMLParserDelegate> {
    NSUInteger state;
    NSUInteger rating;
    NSMutableString *currentElement;
}

//@property (nonatomic, strong) NSMutableOrderedSet *result;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) Post *currentPost;

@end

@implementation HRRSSParser

+ (void)updateRatingsInManagedObjectContext:(NSManagedObjectContext *)context withCompletionHandler:(void (^)(BOOL))completionHandler{
    HRRSSParser *rssParser = [[HRRSSParser alloc] init];
    rssParser->state = Wait;
    rssParser->rating = 999;
    rssParser.context = context;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://habrahabr.ru/rss/best/"]];
    parser.delegate = rssParser;
    completionHandler([parser parse]);
}

#pragma mark - NSXMLParserDelegate protocol implementation

// документ начал парситься
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// парсинг окончен
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

// если произошла ошибка парсинга
-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    //NSLog(@"%s error %@ at string:%d",__PRETTY_FUNCTION__,[parseError localizedDescription],[parser lineNumber]);
}

// если произошла ошибка валидации
-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    NSLog(@"%s error %@ at string:%d",__PRETTY_FUNCTION__,[validationError localizedDescription],[parser lineNumber]);
}

// встретили новый элемент
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    switch (state) {
        case Wait:
            // ждем начала элемента <li>
            if ([elementName isEqualToString:@"item"]) {
                state = FoundItem;
                // Создать текущий элемент???
            }
            break;
            
        case FoundItem:
            if ([elementName isEqualToString:@"link"]) {
                state = FoundLink;
                currentElement = [[NSMutableString alloc] init];
            } else if ([elementName isEqualToString:@"description"]) {
                state = FoundDescription;
                currentElement = [[NSMutableString alloc] init];
            }
            break;
            
        default:
            break;
    }
    /*
     if (collectingData) {
     if ([elementName isEqual:@"div"]) {
     if ([[attributeDict objectForKey:@"class"] isEqual:stopTag]) {
     collectingData = NO;
     NSLog(@"%@",@"Save array to file");
     //[parser abortParsing];
     }
     }
     if ([elementName isEqual:@"a"]) {
     NSLog(@"%@",@"Create new element");
     //currentItem = [[NSMutableDictionary alloc] init];
     //NSLog(@"url: %@",[attributeDict objectForKey:@"href"]);
     //[currentItem setObject:[[attributeDict objectForKey:@"href"] stringByReplacingOccurrencesOfString:@".html" withString:@""] forKey:@"url"];
     currentItem = [[RSItem alloc] init];
     currentItem.name = [[attributeDict objectForKey:@"href"] stringByReplacingOccurrencesOfString:@".html" withString:@""];
     }
     if ([elementName isEqual:@"img"]) {
     NSLog(@"image: %@",[attributeDict objectForKey:@"src"]);
     //[currentItem setObject:[attributeDict objectForKey:@"src"] forKey:@"image"];
     //NSLog(@"name: %@",[attributeDict objectForKey:@"alt"]);
     //[currentItem setObject:[attributeDict objectForKey:@"alt"] forKey:@"name"];
     // start loading picture
     //[currentItem setObject:_notificationName forKey:@"temp_section"];
     //[currentItem setObject:[NSNumber numberWithUnsignedInteger:[_result count]] forKey:@"temp_index"];
     //[loader loadResource:@"image" forObject:currentItem];
     currentItem.imageUrl = [attributeDict objectForKey:@"src"];
     currentItem.title = [attributeDict objectForKey:@"alt"];
     //[currentItem loadImage:self]; //загружать изображения будем из модели
     //NSLog(@"%@",@"Save element to array");
     //[_result addObject:currentItem];
     //[waitForLoading addObject:currentItem];
     //if ([delegate respondsToSelector:@selector(foundItem:)]) {
     //[delegate performSelector:@selector(foundItem:) withObject:currentItem];
     //}
     [self.delegate foundItem:currentItem];
     }
     } else {
     if ([elementName isEqual:@"div"]) {
     if ([[attributeDict objectForKey:@"class"] isEqual:startTag]) {
     collectingData = YES;
     }
     }
     }*/
    //NSLog(@"start element:%@\n",elementName);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSUInteger postNumber;
    NSArray *pathConponents;
    switch (state) {
        case FoundLink:
            pathConponents = [currentElement pathComponents];
            postNumber = [[pathConponents objectAtIndex:(pathConponents.count - 2)] integerValue];
            NSLog(@"Post id:%d",postNumber);
            self.currentPost = [Post postWithId:postNumber inManagedObjectContext:self.context];
            self.currentPost.rating = rating--;
            state = FoundItem;
            break;
            
        case FoundDescription:
            // TODO: parse description for image url
            //[currentElement removeTag:@"a"];
            NSLog(@"%s %@",__PRETTY_FUNCTION__,currentElement);
            state = FoundItem;
            break;
            
        case FoundItem:
            if ([elementName isEqualToString:@"item"]) {
                //if (leftParseItems) {
                    // TODO: item parsing complete
                    state = Wait;
                    //rating--;
                //} else {
                    //[parser abortParsing];
                //}
            }
            break;
            
        default:
            break;
    }
    //NSLog(@"end element:%@\n",elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"%s characters:%@",__PRETTY_FUNCTION__,string);
    switch (state) {
        case FoundLink:
            [currentElement appendString:string];
            break;
            
        default:
            break;
    }
    //NSLog(@"found characters:%@\n",string);
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if (state == FoundDescription) {
        currentElement = [[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding] mutableCopy];
        //NSLog(@"%s %@",__PRETTY_FUNCTION__,CDATABlock);
    }
}

@end
