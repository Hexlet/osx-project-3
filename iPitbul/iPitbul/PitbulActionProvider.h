//
//  PitbulCommandProvider.h
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 12/2/12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PitbulAction;

@interface PitbulActionProvider : NSObject

@property (nonatomic, readonly) NSArray *managementActions;
@property (nonatomic, readonly) NSArray *serviceActions;
@property (nonatomic, readonly) NSArray *totalActions;

- (PitbulAction *)actionByTitle:(NSString *)title;

@end
