//
//  Cell.h
//  DNA-project-3
//
//  Created by Sergey on 22.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Cell : NSObject {
    NSArray* arrayATGC;
    NSInteger dnaLenght;
  //  NSInteger hammingDistance;
}

@property (nonatomic, retain) NSMutableArray* DNA;
@property (nonatomic) NSInteger hammingDistance;

-(void)initWithDNALenght:(NSInteger) d;
-(int)calculateHammingDistance:(Cell*) c;
-(void)mutate:(NSInteger) percent;
-(NSString*)stringDNA;
-(Cell*)crossing:(Cell*) c;


@end
