//
//  Cell.h
//  DNA
//
//  Created by Администратор on 10/31/12.
//  Copyright (c) 2012 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LETTERS @"ATGC" // возможные значения элемента клетки (использовать uppercase)

@interface Cell : NSObject

@property NSMutableArray *DNA;

- (id) initWithLength: (int) length;
- (id) initWithString: (NSString*) s;

- (void) changeLength: (int) length;
- (int) hammingDistance: (Cell*) c; // хэммингово расстояние от данной клетки до клетки c
+ (Cell *) Cell1:(Cell*) c1 crossWithCell2:(Cell*) c2;  // скрещивание клетки с1 и клетки c2
+ (NSString*) generateRandomNucletoid;
- (void)mutate: (int) x; // мутирование х% клетки

- (void) print;
- (NSString*) description;

@end
