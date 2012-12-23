//
//  SettingsProvider.m
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 12/21/12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import "SettingsUtils.h"
#import "Constants.h"

@implementation SettingsUtils

+ (NSDictionary *)settings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [userDefaults objectForKey:PITBUL_PHONE_NUMBER], PITBUL_PHONE_NUMBER,
            [userDefaults objectForKey:PITBUL_PASSWORD], PITBUL_PASSWORD,
            nil];
}

+ (void)saveSettings:(NSDictionary *)settings {
    if (settings != nil && settings.count != 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

        for(id key in settings) {
            [userDefaults setObject:[settings objectForKey:key] forKey:key];
        }
        
        [userDefaults synchronize];
    }
}

+ (BOOL)isSettingsConfigured {
    return [SettingsUtils pitbulPhoneNumber] != nil && [SettingsUtils pitbulPassword] != nil;
}

+ (NSString *)pitbulPhoneNumber {
    return [[SettingsUtils settings] objectForKey:PITBUL_PHONE_NUMBER];
}

+ (NSString *)pitbulPassword {
    return [[SettingsUtils settings] objectForKey:PITBUL_PASSWORD];
}

@end
