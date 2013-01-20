//
//  AppDefaults.m
//  iDNA
//
//  Created by Dmitry Davidov on 20.01.13.
//  Copyright (c) 2013 Dmitry Davidov. All rights reserved.
//

#import "AppDefaults.h"


NSString *const IDNAMinSizeKey = @"minSize";
NSString *const IDNAMaxSizeKey = @"maxSize";
NSString *const IDNAMinLengthKey = @"minLength";
NSString *const IDNAMaxLengthKey = @"maxLength";


@implementation AppDefaults

+ (void)setupDefaults
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    
    [defaults setObject:[NSNumber numberWithUnsignedInteger:1] forKey:IDNAMinSizeKey];
    [defaults setObject:[NSNumber numberWithUnsignedInteger:1000] forKey:IDNAMaxSizeKey];
    [defaults setObject:[NSNumber numberWithUnsignedInteger:1] forKey:IDNAMinLengthKey];
    [defaults setObject:[NSNumber numberWithUnsignedInteger:100] forKey:IDNAMaxLengthKey];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

@end
