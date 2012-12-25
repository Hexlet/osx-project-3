//
//  Cell.h
//  iDNA
//
//  Created by Vadim Iskuchekov on 24.12.12.
//  Copyright (c) 2012 Llama on the Boat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject {
    NSMutableArray *DNA; // массив с ДНК
    NSArray *Nucleotides; // массив с нуклеотидами
}
@property NSMutableArray *DNA;

- (id)initWithLength:(int)length; // инициализация и генерирование цепочки с указанной длиной ДНК
- (void)generationDna:(int)length; // геренация случайной ДНК
- (NSString*)print; // возвращает ДНК в виде строки
- (NSNumber*)hammingDistance:(Cell *)inCell;  // возвращаем количество не совпавших нуклеотидов
- (void)crossWithCell:(Cell *)inCell byTypeOfCross:(NSString*)typeCross; // скрещивание
- (void)mutate:(int)x; // мутация популяции

@end
