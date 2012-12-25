//
//  HRPDataLoader.m
//  HabraReader Prototype
//
//  Created by Sergey Starukhin on 18.09.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRPDataLoader.h"
//#import "NSMutableString+RemoveTag.h"
#import "GenericHub.h"
#import "Post+Create.h"
#import "Author+Create.h"
#import "Hub+Create.h"
#import "Company+Create.h"
#import "HTMLParser.h"

enum HRParsingState {
    Stop = 0,
    Parsing = 1,
    WaitForSubj = 2,
    WaitForHub = 3,
    WaitForAuthorAndDate = 4,
    WaitForNumberOfComments= 5
    };

typedef void (^work_complete_t)(BOOL result);

@interface HRPDataLoader () <NSURLConnectionDataDelegate, HTMLParserDelegate> {

    work_complete_t syncCompleteHandler;
    NSUInteger state;
    NSMutableString *currentElement;
    NSMutableDictionary *post;
    BOOL hubIsACompany;

}

@property (nonatomic, strong) Post *currentPost;
@property (nonatomic, strong) GenericHub *currentHub;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation HRPDataLoader

@synthesize context = _context;
@synthesize data = _data;
@synthesize currentPost = _currentPost;
@synthesize currentHub = _currentHub;

- (NSMutableData *)data {
    if (!_data) {
        _data = [[NSMutableData alloc] init];
    }
    return _data;
}

#pragma mark - NSURLConnectionDataDelegate protocol implementation

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.data = nil;
    // TODO: Hadle error
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableString *mHabr = [[NSMutableString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    //[mHabr removeTag:@"script"];
    //[mHabr replaceOccurrencesOfString:@"<br>" withString:@"<br/>" options:0 range:NSMakeRange(0, [mHabr length])];
    //[mHabr writeToFile:[@"~/Documents/mhabrahabr.xml" stringByExpandingTildeInPath] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    //NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[mHabr dataUsingEncoding:NSUTF8StringEncoding]];
    HTMLParser *parser = [[HTMLParser alloc] initWithString:mHabr];
    parser.delegate = self;
    self->syncCompleteHandler([parser parse]);
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

// если произошла ошибка валидации
-(void) parser:(HTMLParser *)parser validationErrorOccurred:(NSError *)validationError {
    //NSLog(@"%s error %@ at string:%d",__PRETTY_FUNCTION__,[validationError localizedDescription],[parser lineNumber]);
}

// встретили новый элемент
- (void)parser:(HTMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    switch (state) {
        case Stop:
            // ждем начала элемента <li>
            if ([elementName isEqual:@"li"]) {
                state = Parsing;
                // Создать текущий элемент???
            }
            break;
        case Parsing:
            if ([elementName isEqual:@"a"]) {
                // извлекаем информацию из тега <a>
                if ([[attributeDict objectForKey:@"class"] isEqual:@"t"]) {
                    //NSLog(@"Found post");
                    //NSLog(@"uniqId: %@",[[attributeDict objectForKey:@"href"] lastPathComponent]);
                    self.currentPost = [Post postWithId:[[[attributeDict objectForKey:@"href"] lastPathComponent] integerValue] inManagedObjectContext:self.context];
                    //post = [[NSMutableDictionary alloc] init];
                    //[post setObject:[[attributeDict objectForKey:@"href"] lastPathComponent] forKey:@"uniqId"];
                    //NSLog(@"//Проверили существование элемента: если есть - state = stop, если нет - создали новый");
                    state = WaitForSubj;
                    currentElement = [[NSMutableString alloc] init];
                } else if ([[attributeDict objectForKey:@"class"] isEqual:@"hub"]) {
                    // Если в ссылке (аттрибут href) присутствует слово company: то хаб - блог компании
                    hubIsACompany = [[attributeDict objectForKey:@"href"] rangeOfString:@"company"].location != NSNotFound;
                    //NSLog(@"Found hub: %@",[[attributeDict objectForKey:@"href"] lastPathComponent]);
                    if (hubIsACompany) {
                        // company
                        self.currentHub = [Company companyWithName:[[attributeDict objectForKey:@"href"] lastPathComponent] inManagedObjectContext:self.context];
                    } else {
                        // hub
                        self.currentHub = [Hub hubWithName:[[attributeDict objectForKey:@"href"] lastPathComponent] inManagedObjectContext:self.context];
                    }
                    [self.currentPost addHubsObject:self.currentHub];
                    state = WaitForHub;
                    currentElement = [[NSMutableString alloc] init];
                } else if ([[attributeDict objectForKey:@"class"] isEqual:@"comments"]) {
                    state = WaitForNumberOfComments;
                }
            } else if ([elementName isEqual:@"em"]) {
                // извлекаем информацию из тега <em>
                state = WaitForAuthorAndDate;
                currentElement = [[NSMutableString alloc] init];
            } /*else if ([elementName isEqual:@"span"]) {
                if ([[attributeDict objectForKey:@"class"] isEqual:@"profiled_hub"]) {
                    NSLog(@"установили у сохраненого хаба аттрибут Профильный хаб");
                }
            }*/
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

- (void)parser:(HTMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//if (collectingData) {
//
//if ([elementName isEqual:@"a"]) {
//    NSLog(@"%@",@"Save element to array");
//}
//if ([elementName isEqual:@"div"]) {
//    NSLog(@"%@",@"Save array to file");
//    collectingData = NO;
//    [parser abortParsing];
//}
//}
// если элемент title закончился - добавим строку в результат
//if ( m_isTitle ) {
//    [m_titles addObject:m_title];
//    [m_title release];
//}
    switch (state) {
        case WaitForSubj:
            if ([elementName isEqual:@"a"]) {
                //NSLog(@"title: %@",currentElement);
                self.currentPost.title = currentElement;
                //NSLog(@"Назначили текущему элементу название");
                state = Parsing;
            }
            break;
        case WaitForHub:
            if ([elementName isEqual:@"a"]) {
                //NSLog(@"Hub title: %@",currentElement);
                //NSLog(@"Hub isCompany: %@", hubIsACompany ? @"YES" : @"NO");
                NSMutableString *hubName = [currentElement mutableCopy];
                if (hubIsACompany) {
                    [hubName replaceOccurrencesOfString:@"Блог компании " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, currentElement.length -1)];
                }
                self.currentHub.title = hubName;
                //NSLog(@"Добавили хаб к текущему элементу и установили аттрибут компании");
                state = Parsing;
            }
            break;
        case WaitForAuthorAndDate:
            if ([elementName isEqual:@"em"]) {
                NSArray *authorAndDate = [currentElement componentsSeparatedByString:@","];
                //NSLog(@"Author nickName: %@",[authorAndDate objectAtIndex:0]);
                self.currentPost.author = [Author authorWithName:[authorAndDate objectAtIndex:0] inManagedObjectContext:self.context];
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
                self.currentPost.publicationDate = date;
                state = Parsing;
            }
            break;
        case WaitForNumberOfComments:
            if ([elementName isEqual:@"span"]) {
                [currentElement deleteCharactersInRange:NSMakeRange(0, 1)];
                //NSLog(@"counOfComments: %d",[currentElement intValue]);
                self.currentPost.countOfComments = [currentElement intValue];
                state = Parsing;
            }
            break;
            
        default:
            if ([elementName isEqual:@"li"]) {
                state = Stop;
            }
            break;
    }
    //NSLog(@"end element:%@\n",elementName);
}

- (void)parser:(HTMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"%s characters:%@",__PRETTY_FUNCTION__,string);
    switch (state) {
        case WaitForSubj:
        case WaitForHub:
        case WaitForAuthorAndDate:
            [currentElement appendString:string];
            break;
        case WaitForNumberOfComments:
            currentElement = [string mutableCopy];
            break;
            
        default:
            break;
    }
// если сейчас получаем значение элемента title
// добавим часть его значения к строке
//if ( m_isTitle ) {
//  [m_title appendString:string];
//}
//NSLog(@"found characters:%@\n",string);
}

#pragma mark - public API

+ (void)syncDatabaseWithContext:(NSManagedObjectContext *)managedObjectContext fromURL:(NSURL *)URL withCompletionHandler:(void (^)(BOOL))completionHandler{
    HRPDataLoader *loader = [[self alloc] init];
    loader.context = managedObjectContext;
    loader->syncCompleteHandler = completionHandler;
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:request delegate:loader];
    if (! newConnection) {
        // TODO: Handle error
        //loader.data = [[NSMutableData alloc] init];
    }
}
/*
+ (void)syncHabraDataWithContext:(NSManagedObjectContext *)context fromPageNumber:(NSUInteger)number withCompletionHandler:(void (^)(BOOL))completionHandler {
    [self syncDatabaseWithContext:context fromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.habrahabr.ru/page%d/", number]] withCompletionHandler:completionHandler];
}

+ (void)syncHabraDataWithContext:(NSManagedObjectContext *)context fromHub:(NSString *)hub withCompletionHandler:(void (^)(BOOL))completionHandler {
    [self syncDatabaseWithContext:context fromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.habrahabr.ru/hub/%@/", hub]] withCompletionHandler:completionHandler];
}

+ (void)syncHabraDataWithContext:(NSManagedObjectContext *)context fromCompany:(NSString *)company withCompletionHandler:(void (^)(BOOL))completionHandler {
    [self syncDatabaseWithContext:context fromURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://m.habrahabr.ru/company/%@/", company]] withCompletionHandler:completionHandler];
}
*/
@end
