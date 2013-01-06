//
//  Cell.h
//  NDA
//
//  Created by Tsyganov Stanislav on 12.11.12.
//  Copyright (c) 2012 Tsyganov Stanislav. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDnaLength 100

@interface Cell : NSObject
@property NSMutableArray* DNA;

-(int)hammingDistance:(Cell*)anotherCell;
-(id)initWithLength:(NSInteger)length;
+(NSString*)stringForPrfectCellDNAWithLength:(NSInteger)length;
-(int)hammingDistanceToString:(NSString *)anotherCellDNAString;
-(id)initCellFromFirst:(Cell*)first andSecond:(Cell*)second;

@end
