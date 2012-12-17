//
//  YKDNA.h
//  iDNA
//
//  Created by Yuri Kirghisov on 17.12.12.
//  Copyright (c) 2012 Yuri Kirghisov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKDNA : NSObject {
    NSArray *dnaLetters;
}

@property (assign) NSString *dnaString;

- (YKDNA *)initWithLength:(NSUInteger)length;

- (NSUInteger)hammingDistance;
- (void)mutateWithPercentage:(NSUInteger)percentage;
- (NSComparisonResult)compareHammingDistanceToHammingDistanceOfDNA:(YKDNA *)aDNA;

@end
