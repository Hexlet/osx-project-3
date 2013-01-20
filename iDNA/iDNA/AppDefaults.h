//
//  AppDefaults.h
//  iDNA
//
//  Created by Dmitry Davidov on 20.01.13.
//  Copyright (c) 2013 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const IDNAMinSizeKey;
extern NSString *const IDNAMaxSizeKey;


@interface AppDefaults : NSObject

+ (void)setupDefaults;

@end
