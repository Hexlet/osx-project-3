//
//  Cell.h
//  iDNA
//
//  Created by Stas on 12/27/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject {
    NSMutableArray *dna;
}

+ (void) setDnaLength: (int) a;                         // метод класса, устанавливающий длину цепочки ДНК каждой сособи популяции
- (int) hammingDistance: (const Cell*) cell;            // прототип метода hammingDistance
- (id) print;                                           // прототип метода print
- (void) papsexwith: (Cell*)pap momsex: (Cell*)mom;     // прототип метода скрещивания
- (void) mutate: (NSInteger) percent;                   // прототип метода мутации
const NSString* newElement(const NSString* element);    // прототип функции, возвращающей элемент цепочки ДНК, отличной от принимаемой

@end
