//
//  DNAKit.h
//  DNAKit
//
//  Created by Dmitry Davidov on 22.12.12.
//  Copyright (c) 2012 Dmitry Davidov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNA : NSObject

@property (readonly) NSUInteger length;

- (id)initWithLength:(NSUInteger)length;

+ (DNA *)dnaWithLength:(NSUInteger)length;

@end
