//
//  Cell.h
//  DNA
//
//  Created by Александр Борунов on 01.11.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "Protein.h"




@interface Cell : NSObject <NSCoding> {
    NSMutableArray *chain;  // цепочку из Proteine храним тут
    NSInteger dnalength;
    
}

-(id)initWithDNAlength:(NSInteger)dl;
- (void) mutate: (int) percentageMutations;

- (int) hammingDistance: (Cell*)comparedCell;  // метод для проверки "различий" двух цепочек генов. просто количество отличий в штуках

// то что мне нужно для отладки и удобства работы:

- (void) print;  // напечатать всю цепочку
- (NSString*)printToString;
- (id) initFromCell: (Cell*)sourceCell; // иногда хочется создать цепочку копированием
- (id) initFromString: (NSString*)sourceString;  // иногда хочется создать цепочку из строки
- (id) initFromSex: (Cell*)father With:(Cell*)mother;
- (void) setAinIndex: (int) index; // проверочка. элемент index устанавливаем в A


@end


