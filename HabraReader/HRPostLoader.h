//
//  HRPostLoader.h
//  HabraReader
//
//  Created by Sergey Starukhin on 29.11.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRPostLoader : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *comments;

- (void)loadPostNumber:(NSUInteger)number withCompletionHandler:(void (^)(NSString *))completionHandler;

@end
