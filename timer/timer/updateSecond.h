//
//  updateSecond.h
//  timer
//
//  Created by Максим on 18.12.12.
//  Copyright (c) 2012 CarelessApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface updateSecond : NSObject
@property NSString *timeLeft;
@property int degree;

-(void)updateString:(NSString *)key;
-(NSString *)print;


@end
