//
//  Cell.h
//  DNA-project-3
//
//  Created by Sergey on 22.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//static NSArray* arrayATGCQ;

@interface Cell : NSObject <NSCoding> {
    NSArray* arrayATGC;
    NSInteger dnaLenght; 
}

@property (nonatomic, retain) NSMutableArray* DNA;
@property (nonatomic) NSInteger hammingDistance;

-(void)fillDNALenght:(NSInteger) d;
-(NSString*)fillDNAString:(NSString*) s;
-(void)calculateHammingDistance:(Cell*) c;
-(void)mutate:(NSInteger) percent;
-(NSString*)stringDNA;
-(NSMutableArray*)crossing:(Cell*) c;


@end
