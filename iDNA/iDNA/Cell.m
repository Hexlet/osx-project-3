//
//  Cell.m
//  iDNA
//
//  Created by Anatoly Yashkin on 22.12.12.
//  Copyright (c) 2012 Anatoly Yashkin. All rights reserved.
//

#import "Cell.h"
#import <ScreenSaver/ScreenSaver.h>

@implementation Cell

+(NSString *)getRandomDNA:(NSInteger)dnaLength{
    NSString *tmpString=@"";
    
    for (int i=0; i<dnaLength; i++) {
        tmpString=[tmpString stringByAppendingString:[Cell getRandomDNAPart:nil]];
    }
    
    return tmpString;
}



//Генерируем случайным образом буковку для последовательности ДНК
//удобно будет передавать в этот метод элемент, который будем менять.
+(NSString *) getRandomDNAPart:(id)replasingPart
{
    NSMutableArray *DNAParts = nil;
    int randomCounter=0;
    
    if (!DNAParts) {
        DNAParts = [NSMutableArray arrayWithObjects:@"A",@"T",@"G",@"C", nil];
    }
    
    if (replasingPart==nil) {
        randomCounter = arc4random_uniform(4);
    }
    else
    {
        [DNAParts removeObject:replasingPart];
        randomCounter = arc4random_uniform(3);
    }
    
    return [NSString stringWithFormat:@"%@",[DNAParts objectAtIndex:randomCounter]];
    
    
}

//Метод считает расстояние хемминга для двух последовательностей ДНК
+(NSInteger)hammingDistanceForDna:(NSString *)firstDNA andDNA:(NSString *)secondDNA{
    
    NSInteger tmpLength=[firstDNA length];
    NSInteger hDistance=0;
    
    //Маленькую проверочку на длину ДНК, так как метод хемминга работает только для строк с одинаковой длиной
    if([firstDNA length]==[secondDNA length]){
        for (int i=0; i<tmpLength; i++) {
            if ([firstDNA characterAtIndex:i]!=[secondDNA characterAtIndex:i]){
                hDistance++;
            }
        }
    }
    else{
        [NSException raise:@"Length error" format:@"DNA should be with equal lengths"];
    }
    
    return hDistance;
}


//Метод скрещивания 2х ДНК
+(NSString *)makeLoveForDNA:(NSString *)firstDNA andDNA:(NSString *)secondDNA{
    BOOL trigger=YES;
    NSInteger length=[firstDNA length];
    NSMutableString *babyDNA =[NSMutableString stringWithCapacity:length];
    
    if ([firstDNA length]==[secondDNA length]) {
        
        
        
        NSInteger position =3;// arc4random_uniform(3);
       
        
        
        switch (position) {
            case 0:                
                //Способ 50/50
                [babyDNA appendString:[firstDNA substringToIndex:length/2]];
                [babyDNA appendString:[firstDNA substringFromIndex:length/2]];
                break;
            case 1 :
                
                //по 1 символу из каждого
                for (int i=0; i<length; i++) {
                    if (trigger) {
                        [babyDNA appendString:[firstDNA substringWithRange:NSMakeRange(i,1)]];
                    }
                    else{
                        [babyDNA appendString:[secondDNA substringWithRange:NSMakeRange(i,1)]];
                    }
                    
                    trigger=!trigger;
                }
                
                break;
            default:
                //20% из первой + 60% из второй + 20% из первой
                [babyDNA appendString:[firstDNA substringToIndex:length/5]];
                [babyDNA appendString:[secondDNA substringWithRange:NSMakeRange(length/5, length*3/5)]];
                [babyDNA appendString:[firstDNA substringFromIndex:length*4/5]];
                break;
        }
        
    }
    else
        [NSException raise:@"Length error" format:@"DNA should be with equal lengths"];
    
    return babyDNA;
}

//метод мутирует нужное нам количество букв ДНК
+(NSString *)mutateDNA:(NSString *)DNA  withPercent:(NSInteger)percent
{
    
    //проверим, не пытается ли кто-нибудь мутировать 146% нашей ДНК
    if (percent>=0 && percent<=100) {
                
        //переведем проценты в числа
        NSInteger markersForMutation = percent*[DNA length]/100;
        
        //Создадим массив индексов, чтобы не повторяться
        NSMutableArray *indexes = [[NSMutableArray alloc] initWithCapacity:DNA.length]; // Массив для индексов

        
        //заполним массив индексов
        for (int i=0; i<DNA.length; i++) {
            [indexes addObject:[NSNumber numberWithInt:i]];
        }
        
        for (int modified=0;modified<markersForMutation;modified++) {
            NSUInteger randomKey = arc4random_uniform(indexes.count);
            NSUInteger indexToModify = [[indexes objectAtIndex:randomKey] integerValue]; // запоминаем индекс
            DNA=[DNA stringByReplacingCharactersInRange:NSMakeRange(indexToModify, 1) withString:[Cell getRandomDNAPart:[DNA substringWithRange:NSMakeRange(indexToModify, 1)]]];
            [indexes removeObjectAtIndex:randomKey];//удаляем уже использованный индекс.
        }
    }
    else
        [NSException raise:@"Persent error" format:@"Percent can be >=0 and <=100"];

    
    return DNA;
}    
    


@end
