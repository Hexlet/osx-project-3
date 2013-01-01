//
//  CellValueTransformer.m
//  iDNA
//
//  Created by Tolya on 25.12.12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "CellValueTransformer.h"

@implementation CellValueTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return value ? [value stringValue] : nil;
}

@end
