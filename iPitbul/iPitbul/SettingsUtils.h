//
//  SettingsProvider.h
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 12/21/12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsUtils : NSObject

+ (NSDictionary *)settings;
+ (void)saveSettings:(NSDictionary *)settings;

+ (BOOL) isSettingsConfigured;
+ (NSString *)pitbulPhoneNumber;
+ (NSString *)pitbulPassword;

@end
