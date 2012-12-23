//
//  HVSPopulationOfDna.h
//  iDNA
//
//  Created by VladIslav Khazov on 23.12.12.
//  Copyright (c) 2012 VladIslav Khazov. All rights reserved.
// Популяция ДНК

#import <Foundation/Foundation.h>

@interface HVSPopulationOfDna : NSObject

//Свойства популяции ДНК, определяющие размер популяции, размер 1-ой ДНК и процент мутации.
@property NSInteger populationSize;
@property NSInteger populationLengthDna;
@property NSInteger populationRate;
// Массив который хранит объекты типа ДНК (HVSCellDna)
@property NSMutableArray *populationDNA;

-(id) init;

@end
