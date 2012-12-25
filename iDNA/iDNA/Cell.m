//
//  Cell.m
//  iDNA
//
//  Created by Vadim Iskuchekov on 24.12.12.
//  Copyright (c) 2012 Llama on the Boat. All rights reserved.
//

#import "Cell.h"

@implementation Cell
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)mutate:(int)x {
    if ((x > 0) && (x <= 100)) {
        NSMutableArray *tempDNA = [[NSMutableArray alloc]init];
        int save = ([DNA count] - ([DNA count] / 100 * x));
        for (int i = 0; i < save; i++) {
            [tempDNA addObject:[DNA objectAtIndex:i]];
        }
        for (int i = save; i < [DNA count]; i++) {
            [tempDNA addObject:[Nucleotides objectAtIndex:arc4random()%4]];
        }
        _DNA = tempDNA; 
//        NSMutableArray *modifedNucleotides = [[NSMutableArray alloc] init]; // массив с индексами уже измененных нуклеотидов
//        bool mutated = NO; // y - мутация произведена, n — мутация не произведена
//        int index; // интекс изменяемого объекта
////        NSMutableArray *tempDNA = [[NSMutableArray alloc]init]; 
//        
//        for (unsigned int i = 0; i < ([DNA count] / x); i++) {
//            while (!mutated) { // пока мутация не произошла
//                mutated = NO;
//                index = arc4random()%x + 1; // выбираем случайный элемент в массиве
//                
//                if (![modifedNucleotides containsObject: [NSString stringWithFormat:@"%d", index]]) {  // если выбранный элемент еще не мутировал, то
//                    [modifedNucleotides addObject:[NSString stringWithFormat:@"%d", index]];  // запоминаем индекс уже мутировавшего элемента, что бы не мутировать его еще раз
////                    [tempDNA addObject:[Nucleotides objectAtIndex:arc4random()%4]];
//                    [_DNA insertObject:[Nucleotides objectAtIndex:arc4random()%4] atIndex:index]; // мутируем элемент
//                    
//                    mutated = YES;
//                } // если выбранный элемент уже мутировал, генерируем следущих случайный индекс
//            }
//        }
//        NSLog(@"DNA count = %ld",[DNA count]);
//        NSLog(@"tempDNA count = %ld",[tempDNA count]); 
//        DNA = tempDNA; 
    } else NSLog(@"Значение х должно быть в пределах интервала (0..100)");
}

- (void)crossWithCell:(Cell *)inCell byTypeOfCross:(NSString*)typeCross {
    if (inCell) {
        
//        NSLog(@"DNA: %@", [self print]);
//        NSLog(@"inC: %@", [inCell print]);
        
        Cell *resultCell = [[Cell alloc]initWithLength:[DNA count]];
        if (typeCross == @"1") {
//            NSLog(@"Первый тип");
            // первый тип, 50 на 50 процентов
            for (int i = 0; i < ([DNA count] / 2); i++) {
                [[resultCell DNA]addObject:[DNA objectAtIndex:i]]; 
            }
            for (int i = ([DNA count] / 2); i < [DNA count]; i++) {
                [[resultCell DNA]addObject:[[inCell DNA] objectAtIndex:i]];
            }
//            NSLog(@"resDNA: %@", [resultCell print]); 
        _DNA = [resultCell DNA];
//            NSLog(@"DNA: %@", [self print]); 
        return;
        }else if (typeCross == @"2") {
//            NSLog(@"Второй тип");
            // второй тип, каждый втрой процент
            if ([DNA count] % 2 == 0) {
                for (int i = 0; i < ([DNA count] / 2); i++) {
                    [[resultCell DNA]addObject:[DNA objectAtIndex:i]];
                    [[resultCell DNA]addObject:[[inCell DNA] objectAtIndex:i]];
                }
//                NSLog(@"resDNA: %@", [resultCell print]); 
                _DNA = [resultCell DNA];
                return; 
            }else {
//                NSLog(@"Третий тип");
                for (int i = 0; i < ([DNA count] / 2); i++) {
                    [[resultCell DNA]addObject:[DNA objectAtIndex:i]];
                    [[resultCell DNA]addObject:[[inCell DNA] objectAtIndex:i]];
                }
                [[resultCell DNA]addObject:[DNA objectAtIndex:0]];
//                NSLog(@"resDNA: %@", [resultCell print]); 
                _DNA = [resultCell DNA];
                return; 
            }
        }else if (typeCross == @"3") {
            // третий тип, 20 на 60 на 20 процентов
// пусть пока так
            for (int i = 0; i < ([DNA count] / 2); i++) {
                [[resultCell DNA]addObject:[DNA objectAtIndex:i]];
                [[resultCell DNA]addObject:[[inCell DNA] objectAtIndex:i]];
            }
            _DNA = [resultCell DNA];
            return; 
        }else {
            NSLog(@"Ошибка в определении типа скрещивания");
        }
    } NSLog(@"Пустой входящий ДНК");
}

- (id)initWithLength:(int)length {
    if (self = [super init]) {
        Nucleotides = [[NSArray alloc] initWithObjects:@"A", @"T", @"G", @"C", nil];
        DNA = [[NSMutableArray alloc] init];
        [self generationDna:length]; 
    }
    return self;
}

- (void)generationDna:(int)length {
    [DNA removeAllObjects]; 
    for (int i = 0; i < length; i++) {
        [DNA addObject:[Nucleotides objectAtIndex:arc4random()%4]];
    }
}

- (NSString*)print {
    if (DNA) {
        NSMutableString *dna = [[NSMutableString alloc]init];
        for (int i = 0; i < DNA.count; i++) {
            [dna insertString:[DNA objectAtIndex:i] atIndex:i];
        }
        return dna;
    } return @"Error";
}

- (NSNumber*)hammingDistance:(Cell *)inCell {
    unsigned int distCount = 0;
    for (unsigned int i = 0; i < [inCell->DNA count]; i++) {
        if ([DNA objectAtIndex:i] != [inCell->DNA objectAtIndex:i]) {
            distCount++;
        }
    }
    NSNumber *n = [[NSNumber alloc]initWithInt:distCount];
    return n;
}

@end
