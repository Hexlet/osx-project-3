//
//  Cell.m
//  iDNA
//
//  Created by Stas on 12/27/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import "Cell.h"

@implementation Cell

int dnaLength = 20;
const int ELS = 4;
const NSString * elements[ELS] = {@"A", @"T", @"G", @"C"};

// метод класса, определящий длину dna-массива ////////////////////////////////////
+ (void) setDnaLength: (int) a {
    dnaLength = a;
}
///////////////////////////////////////////////////////////////////////////////////


// метод инициализации ////////////////////////////////////////////////////////////
- (id) init {
    self = [super init];
    if (self) {
        dna = [[NSMutableArray alloc] init];
        int count = dnaLength;
        while (count--)
            [dna addObject:elements[arc4random() % ELS]];
    }
    return self;
}
//////////////////////////////////////////////////////////////////////////////////


// метод инициализации ////////////////////////////////////////////////////////////
- (id) initWithA {
    self = [super init];
    if (self) {
        dna = [[NSMutableArray alloc] init];
        int count = dnaLength;
        while (count--)
            [dna addObject:@"A"];
    }
    return self;
}
//////////////////////////////////////////////////////////////////////////////////


// вычисление hammingDistance ////////////////////////////////////////////////////
- (int) hammingDistance: (const Cell*) cell {
    int hamdist = 0;                            // вводим и устанавливаем в ноль переменную, отвечающую за кол-во неодинаковых пар
    int count = dnaLength;                      // вводим переменную-счетчик count, инициализировав ее размером массива
    while (count--)                             // цикл перебора всех эл-тов массива
        if ([[dna objectAtIndex:count] isNotEqualTo:[cell->dna objectAtIndex:count]])   // сравнение
            hamdist++;                          // инкрементация кол-ва
    return hamdist;                             // возврат в вызываемую функцию кол-ва неодинаковых пар
}
///////////////////////////////////////////////////////////////////////////////////


// метод print ////////////////////////////////////////////////////////////////////
- (id) print {
    return [dna componentsJoinedByString:@""];
}
///////////////////////////////////////////////////////////////////////////////////


// процесс скрещивания ////////////////////////////////////////////////////////////
- (void) papsexwith: (Cell*)pap momsex: (Cell*)mom {
    
    int rand = arc4random() % 3;    // три варианта скрещивания (rand = 0, rand = 1, rand = 2)
    int count;

    if (rand == 0) {                // первый вариант
        int middle = dnaLength / 2;
        for (count = 0; count < dnaLength; count++)
            middle <= count ?
            [self->dna replaceObjectAtIndex:count withObject:[mom->dna objectAtIndex:count]]:
            [self->dna replaceObjectAtIndex:count withObject:[pap->dna objectAtIndex:count]];
    }
    
    else if (rand == 1) {           // второй вариант
        for (count = 0; count < dnaLength; count++)
            count % 2 ?
            [self->dna replaceObjectAtIndex:count withObject:[mom->dna objectAtIndex:count]]:
            [self->dna replaceObjectAtIndex:count withObject:[pap->dna objectAtIndex:count]];
    }
    
    else {                          // третий вариант
        int start = (int)dnaLength * 0.2;
        int finish = (int)dnaLength * 0.8;
        for (count = 0; count < dnaLength; count++)
            count >= start && count < finish ?
            [self->dna replaceObjectAtIndex:count withObject:[mom->dna objectAtIndex:count]]:
            [self->dna replaceObjectAtIndex:count withObject:[pap->dna objectAtIndex:count]];
    }
}
//////////////////////////////////////////////////////////////////////////////////////


// мутация ///////////////////////////////////////////////////////////////////////////
- (void) mutate: (NSInteger) percent {
    if (percent == 0)                                // если процент мутации равен нулю,
        return;                                      // то ничего не делаем
    if (dnaLength != 100)                            // если размер массива не равен 100,
        percent = percent * dnaLength / 100;         // пересчитываем процент
    
    // создание массива из элементов BOOL, где столько значений YES, сколько процентов нужно изменить.
    BOOL mas [dnaLength];
    int count = dnaLength;                          // присваиваем переменной count значения количества эл-тов массива
    while (count--)                                 // цикл перебора всех эл-тов массива
        mas [count] = count < percent? YES : NO;    
    
    // перемешиваем массив логических эл-тов BOOL
    count = dnaLength;                               // присваиваем переменной count значения количества эл-тов массива
    int tempIndex;                                   // вводим переменную-буфер для запоминания индекса изменяемого эл-та
    BOOL tempValue;                                  // вводим переменную-буфер для запоминания значения изменяемого эл-та
    while (count--) {                                // цикл перебора всех эл-тов массива
        tempIndex = arc4random() % dnaLength;        // заполняем переменную-буфер индексом изменяемого эл-та
        tempValue = mas [tempIndex];                 // заполняем переменную-буфер изменяемым эл-том
        mas [tempIndex] = mas [count];               // меняем местами 1
        mas [count] = tempValue;                     // меняем местами 2
    }
    
    // процесс мутации
    count = dnaLength;                               // переменной count значения количества эл-тов массива
    while (count--)                                  // цикл перебора всех эл-тов массива
        if (mas[count])                              // изменяем только те эл-ты, для которых в mas [count] == YES
            [dna replaceObjectAtIndex:count withObject:newElement([dna objectAtIndex:count])]; // заменяем элемент
    
}
//////////////////////////////////////////////////////////////////////////////////////


// функция, возвращающая элемент цепочки ДНК, отличной от принимаемой (для мутации)///
const NSString* newElement(const NSString* element) {
    int count;
    for (count = 0; count < ELS; count++)
        if (elements[count] == element)
            break;                                          // здесь мы вычислили индекс эл-та (от 0 до 3). сохранили его в count
    count = (count + 1 + arc4random() % (ELS - 1)) % ELS;   // перезаписываем count любым не начальным индексом
    return elements[count];                                 // возвращаем эл-т по этому случайному (не начальному) индексу
}
//////////////////////////////////////////////////////////////////////////////////////


// добавление или удаление элементов к цепочке ДНК при изменении ее длины ////////////
- (void) addRemoveElements: (int) a {
    int x = a - (int)[dna count];
    if (x == 0)
        return;
    if (x > 0)
        for (int i = 0; i < x; i++)                         //
            [dna addObject:elements[arc4random() % ELS]];   //
    else
        for (int i = 0; i > x; i--)                         //
            [dna removeLastObject];                         //
}
//////////////////////////////////////////////////////////////////////////////////////


// замена элементов объекта Cell элементами из стоки /////////////////////////////////
- (void) cellFromString: (NSString*)string {
    [self->dna removeAllObjects];
    NSString *element;
    for (int i = 0; i < dnaLength; i++) {
        element = [[NSString alloc] initWithFormat:@"%c", [string characterAtIndex:i]];
        [self->dna addObject:element];
    }
}
//////////////////////////////////////////////////////////////////////////////////////

@end
