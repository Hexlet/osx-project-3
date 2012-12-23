//
//  PitbulAction.h
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 12/22/12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CALL, SMS
} PitbulActionType;

@interface PitbulAction : NSObject

@property (nonatomic, retain) NSString *action;
@property (nonatomic, retain) NSString *title;
@property (nonatomic) PitbulActionType type;

+ (PitbulAction *)initWithAction:(NSString *)action andTitle:(NSString *)title;
+ (PitbulAction *)initWithAction:(NSString *)action andTitle:(NSString *)title andType:(PitbulActionType)type;

@end
