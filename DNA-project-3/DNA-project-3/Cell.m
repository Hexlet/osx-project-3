//
//  Cell.m
//  Project1DNK
//
//  Created by Sergey on 02.11.12.
//  Copyright (c) 2012 Sergey. All rights reserved.
//

#import "Cell.h"
//#define kSizeLarge @["A", "T", "G", "C"]

@implementation Cell

@synthesize hammingDistance;
@synthesize DNA = _DNA;

/*
static NSArray* arrayATGCQ = nil;
static dispatch_once_t onceToken;



dispatch_once(&onceToken, ^{
    arrayATGCQ = @[kSizeLarge];
});

dispatch_once ()

dispatch_once(&onceToken, ^{
    arrayATGCQ = [NSArray initWithObjects:@"A", @"T", @"G", @"C",nil];
});
*/

-(id) init {
    self = [super init];
    if (self) {
        arrayATGC = [[NSArray alloc] initWithObjects:@"A", @"T", @"G", @"C",nil];
        _DNA = [[NSMutableArray alloc] init];
        dnaLenght = 0;
    }
    return self;
}

-(void)fillDNALenght:(NSInteger) d {
    NSInteger i;
    if (d > dnaLenght) {
        for (i=dnaLenght; i<d; i++)
            [_DNA addObject:[arrayATGC objectAtIndex: arc4random() % ([arrayATGC count])]]; // добавляем нужное количество
    }
    else if (d < dnaLenght) {
        for (i=dnaLenght-1; i>=d; i--)
            [_DNA removeObjectAtIndex:i]; // удаляем лишние элементы
    }
    dnaLenght = d;
    if ([_DNA count] != dnaLenght) // дополнительная проверка
        NSLog(@"длина ДНК различна %lu <> %lu",[_DNA count], dnaLenght );
}

-(NSString*)fillDNAString:(NSString*) s {
    NSInteger n = [s length];
    // перебираем переданную строку и ищем запрещенные символы
    for (NSInteger i=0; i<n; i++) {
       unichar charAtIndex = [s characterAtIndex:i];
       NSString* charString = [NSString stringWithCharacters:&charAtIndex length:1];
        if (![arrayATGC containsObject:charString]) {
           NSLog(@"запрещенный символ %@",charString);
           return charString;
       }
    }
    // строка нормальная заполняем DNA
   [_DNA removeAllObjects];
    dnaLenght = n;
    for (NSInteger i=0; i<n; i++) {
        unichar charAtIndex = [s characterAtIndex:i];
        NSString* charString = [NSString stringWithCharacters:&charAtIndex length:1];
        [_DNA addObject:charString];
    }
   return @"";
}

-(void) calculateHammingDistance:(Cell*) c {
    hammingDistance = 0;
    for (int i=0; i<dnaLenght; i++)
        if ([[_DNA objectAtIndex:i] isEqualToString: [c.DNA objectAtIndex: i]])
           hammingDistance ++;    
}

-(void)mutate:(NSInteger)percent {
    NSUInteger markersForMutation = percent*dnaLenght/100;
    //Создадим массив индексов, чтобы не повторяться
    NSMutableArray *indexes = [[NSMutableArray alloc] initWithCapacity:dnaLenght]; // Массив для индексов
    //заполним массив индексов
    for (int i=0; i<dnaLenght; i++)
        [indexes addObject:[NSNumber numberWithInt:i]];
    
    for (int i=0; i<markersForMutation; i++) {
        NSUInteger randomKey = arc4random() % indexes.count;
        NSUInteger indexToModify = [[indexes objectAtIndex:randomKey] integerValue]; // запоминаем индекс
        NSString* DNAmodify = [_DNA objectAtIndex:indexToModify]; // что хотим поменять
        NSUInteger numOffset = arc4random() % ([arrayATGC count]-1) + 1; //получаем случайное число 1,2,3
        NSUInteger indexNew = ([arrayATGC indexOfObject:DNAmodify] + numOffset) & 3; // получаем индекс на который меняем
        [_DNA replaceObjectAtIndex:indexToModify withObject:[arrayATGC objectAtIndex:indexNew]]; // заменяем объекты
        [indexes removeObjectAtIndex:randomKey];//удаляем уже использованный индекс.
    }
}

-(NSString*)stringDNA {
    NSString *outString = @"";
    for(int i=0; i<dnaLenght; i++)
        outString = [outString stringByAppendingString:[_DNA objectAtIndex:i]];
    return outString;
}

-(NSMutableArray*)crossing:(Cell*) c {
    NSMutableArray* NewDNA = [[NSMutableArray alloc] init];
    //Скомбинировать их содержание чтобы получить новую ДНК. Комбинирование одним из следующих способов (случайный выбор)
    int num_variant = arc4random() % 3;
//    NSLog(@"Вариант %d",num_variant);
    if (num_variant == 0) {
         //50% первого ДНК + 50% второго ДНК
        int halfdnaLenght = dnaLenght/2; //50%
        for(int i=0; i<dnaLenght; i++) {
            if ((i+1)<halfdnaLenght)
                [NewDNA addObject:[_DNA objectAtIndex:i]];
            else
                [NewDNA addObject:[c.DNA objectAtIndex:i]];
        }
     }
     else if (num_variant == 1) {
         //1 элемент первого ДНК + 1 элемент второго ДНК + 1 элемент первого ДНК + ... и т.д.
         for(int i=0; i<dnaLenght; i++) {
             if ((i%2) == 0)
                 [NewDNA addObject:[_DNA objectAtIndex:i]];
             else
                 [NewDNA addObject:[c.DNA objectAtIndex:i]];
         }
     }
     else {
        //20% первого ДНК + 60% второго ДНК + 20% первого ДНК
        int halfdnaLenght = dnaLenght/5; //20%
        for(int i=0; i<dnaLenght; i++) {
            if ((i+1)<halfdnaLenght || (i+1)>(dnaLenght-halfdnaLenght))
                [NewDNA addObject:[_DNA objectAtIndex:i]];
            else
                [NewDNA addObject:[c.DNA objectAtIndex:i]];
        }
     }
    return  NewDNA;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_DNA forKey:@"DNAKey"]; 
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _DNA = [aDecoder decodeObjectForKey:@"DNAKey"];
        dnaLenght = [_DNA count];
        hammingDistance = 0;
        arrayATGC = [[NSArray alloc] initWithObjects:@"A", @"T", @"G", @"C",nil];
    }
    return self;
}

@end
