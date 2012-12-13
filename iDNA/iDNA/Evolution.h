//
//  Evolution.h
//  iDNA
//
//  Created by Александр Борунов on 13.12.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Evolution : NSObject

+(NSString*)getRandomDNAWithLength:(NSInteger)dnalength;
+(BOOL)isValidDNAString:(NSString *)s;

-(void)startEvolution;
-(void)pauseEvolution;
-(void)resumeEvolution;

@end
