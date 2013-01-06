//
//  IDNPopulation.h
//  IDNA
//
//  Created by Dmitriy Zhukov on 07.01.13.
//  Copyright (c) 2013 Dmitriy Zhukov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IDNCell;

@interface IDNPopulation : NSObject

@property NSMutableArray* population;
@property NSInteger bestDistanseToTarget;
@property BOOL idealDNAstatus;

@end
