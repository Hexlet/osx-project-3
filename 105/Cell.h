//
//  Cell.h
//  105
//
//  Created by Stas on 12/15/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject {
    NSMutableArray *dna;
}

+ (void) setDnaLength: (int) a;                     // метод класса, устанавливающий длину цепочки ДНК каждой сособи популяции
- (int) hammingDistance: (const Cell*) cell;        // прототип метода hammingDistance
- (id) print;                                       // прототип метода print
- (Cell*) sex: (Cell*) cell ;                       // прототип метода скрещивания
- (void) mutate: (int) percent;                     // прототип метода мутации
const NSString* newElement(const NSString* element);// прототип функции, возвращающей элемент цепочки ДНК, отличной от принимаемой

@end
