//
//  HRPostLoader.m
//  HabraReader
//
//  Created by Sergey Starukhin on 29.11.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRPostLoader.h"
#import "NSString+Tags.h"

typedef     void (^load_complete_t)(NSString *content);

@interface HRPostLoader () <NSURLConnectionDataDelegate> {
    load_complete_t loadComplete;
}

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSError *error;

@end

@implementation HRPostLoader

- (void)loadPostNumber:(NSUInteger)number withCompletionHandler:(void (^)(NSString *))completionHandler {
    loadComplete = completionHandler;
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *url = [NSString stringWithFormat:@"http://m.habrahabr.ru/post/%d/",number];
    NSLog(@"Post URL: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection *newConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (newConnection) {
        self.data = [[NSMutableData alloc] init];
    }
}

#pragma mark - NSURLConnectionDataDelegate protocol implementation

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    NSLog(@"http response: %d", response.statusCode);
    if (response.statusCode == 404) {
        // TODO: report error
        [connection cancel];
    } else {
        [self.data setLength:0];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.data = nil;
    // TODO: Hadle error
    NSLog(@"connection error");
    loadComplete(nil);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *pageWithPost = [[NSMutableString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    // TODO: парсить страницу с постом
    NSRange contentRange = [pageWithPost rangeForTag:@"div" withClass:@"p"];
    NSLog(@"%s location:%d length:%d", __PRETTY_FUNCTION__, contentRange.location, contentRange.length);
    self.content = [pageWithPost substringWithRange:contentRange];
    //NSString *comments = [pageWithPost substringWithRange:[pageWithPost rangeForTag:@"div" withClass:@"cmts"]];
    //HTMLParser *parserForComments = [[HTMLParser alloc] initWithString:comments];
    //parserForComments.delegate = self;
    //[parserForComments parse];
    //[self.contentOfPost deleteCharactersInRange:[self.contentOfPost rangeForTag:@"div" withClass:@"tm"]];
    //[self.contentOfPost deleteCharactersInRange:[self.contentOfPost rangeForTag:@"div" withClass:@"bm"]];
    //[self.contentOfPost deleteCharactersInRange:[self.contentOfPost rangeForTag:@"div" withClass:@"ft"]];
    //[self.contentOfPost deleteCharactersInRange:[self.contentOfPost rangeForTag:@"div" withClass:@"m"]];
    //[self.contentOfPost deleteCharactersInRange:[self.contentOfPost rangeForTag:@"div" withClass:@"cmts"]];
    NSRange commentsRange = [pageWithPost rangeForTag:@"div" withClass:@"cmts"];
    if (commentsRange.location != NSNotFound) {
        self.comments = [pageWithPost substringWithRange:commentsRange];
    }
    loadComplete(@"load complete");
}

@end
