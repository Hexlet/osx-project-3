//
//  Population.h
//  iDNA
//
//  Created by Администратор on 1/6/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@interface Population : NSObject {
	Cell* goalDNA;
}

@property NSMutableArray *population;

- (id) initWithSize:(int)size andDNALength:(int)l andGoalDNA:(Cell*) gDNA; // создание популяции размера size, каждая ДНК состоит из l элементов
- (void) sortToGoalDNA; // сортировка популяции по близости к целевой ДНК 
- (void) crossPopulationTopPercent:(int) p; // замена оставшихся (1-p%) особей на результат скрещивания p% лучших особоей
- (void) mutate:(int) x; // мутировать популяцию, каждая ДНК мутируется на х%
- (NSString*) description;

@end
