//
//  Evolution.m
//  iDNA
//
//  Created by Александр Борунов on 13.12.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//

#import "Evolution.h"

@implementation Evolution

+(NSString*)getRandomDNAWithLength:(NSInteger)dnalength{
    NSMutableString *chain = [NSMutableString stringWithCapacity:dnalength];
    while (dnalength-- > 0){
        [chain appendString:@"A"];
    }
    return chain;
}

+(BOOL)isValidDNAString:(NSString *)s{
    BOOL isValid = YES;
    NSCharacterSet *alphabet = [NSCharacterSet characterSetWithCharactersInString: @"ACGT"];
    
    for (NSInteger i=0; i < [s length]; i++){
        if ( ![alphabet characterIsMember:[s characterAtIndex:i]] ){
            isValid = NO;
            break;
        }
    }
    
    return isValid;
}

-(void)startEvolution{
    
}
-(void)pauseEvolution{
    
}
-(void)resumeEvolution{
    
}


@end
