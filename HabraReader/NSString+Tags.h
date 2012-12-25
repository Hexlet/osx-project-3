//
//  NSString+Tags.h
//  HabraReader
//
//  Created by Sergey on 14.11.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tags)

- (NSRange)rangeForTag:(NSString *)tag withClass:(NSString *)classOfTag;
- (NSDictionary *)attributes;

@end
