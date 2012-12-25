//
//  Cell.h
//  iDNA
//
//  Created by Anatoly Yashkin on 22.12.12.
//  Copyright (c) 2012 Anatoly Yashkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

+(NSString *) getRandomDNAPart:(id)replasingPart;
+(NSString *) getRandomDNA:(NSInteger)dnaLength;
+(NSInteger) hammingDistanceForDna:(NSString*)firstDNA andDNA:(NSString*)secondDNA;
+(NSString *)makeLoveForDNA:(NSString*)firstDNA andDNA:(NSString *)secondDNA;
+(NSString *)mutateDNA:(NSString *)DNA  withPercent:(NSInteger)percent;
@end
