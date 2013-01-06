//
//  Cell.m
//  DNA
//
//  Created by Администратор on 10/31/12.
//  Copyright (c) 2012 Администратор. All rights reserved.
//

#import "Cell.h"

@implementation Cell

// инициализация клетки случайным образом с заданным размером
-(id) initWithLength: (int) length {
    self = [super init];
    
    if (self) {
        _DNA = [[NSMutableArray alloc] initWithCapacity: length];
        
        // random init array from our possible letters
        for (int i = 0; i < length; i++) {
            [_DNA addObject: [Cell generateRandomNucletoid]];
        }
    }
    return self;
}

- (id) initWithString:(NSString *)s {
    self = [super init];
    
    if (self) {
        _DNA = [[NSMutableArray alloc] initWithCapacity: [s length]];
        NSString *c;
        // random init array from our possible letters
        for (int i = 0; i < [s length]; i++) {
			c = [[NSString alloc] initWithFormat:@"%c", [s characterAtIndex:i]];
            [_DNA addObject: c];
        }
    }
    return self;
}

// устанавливаем количество нуклеоидов в клетке
- (void) changeLength: (int) length {
	if (length > 0) {
		int size = (int)[_DNA count];
		if ([_DNA count] < length) { // старая длина меньше новой длины, следовательно добавляем элементы			
			for (int i = 0; i < (length - size); i++)
				[_DNA addObject: [Cell generateRandomNucletoid]];
		} else {
			for (int i = 0; i < (size - length); i++)
				[_DNA removeLastObject];
		}
	}
}

// хэммингово расстояние междку клетками
-(int) hammingDistance: (Cell *) c {
    int distance = 0;
    
    for (int i = 0; i < [_DNA count]; i++) {
        if ([[_DNA objectAtIndex: i] isNotEqualTo: [c.DNA objectAtIndex: i]])
            distance++;
    }
    return distance;
}

+ (Cell *) Cell1:(Cell*) c1 crossWithCell2:(Cell*) c2 {
	Cell* child = nil;
	
	if ([c1.DNA count] != [c2.DNA count]) {
		// ошибка - клетки не совпадают размером
		NSLog(@"Crossing error. Size of cells is not equal.");
	}
	else {
		child = [[Cell alloc] initWithLength: (int)[c1.DNA count]];
		int method = arc4random() % 3; // выбираем один из трех случайных методов скрещивания
		if (method == 0) {
			// первый метод - 50% + 50%
			for (int i = 0; i < [c1.DNA count]; i++)
				if (i < [c1.DNA count]/2)
					[child.DNA replaceObjectAtIndex:i withObject:[c1.DNA objectAtIndex:i]];
				else
					[child.DNA replaceObjectAtIndex:i withObject:[c2.DNA objectAtIndex:i]];
		} else if (method == 1) {
			// второй метод - 1 + 1 + ... + 1
			for (int i = 0; i < [c1.DNA count]; i++)
				if (i % 2 == 0)
					[child.DNA replaceObjectAtIndex:i withObject:[c1.DNA objectAtIndex:i]];
				else
					[child.DNA replaceObjectAtIndex:i withObject:[c2.DNA objectAtIndex:i]];
		} else {
			// третий метод - 20% + 60% + 20%
			for (int i = 0; i < [c1.DNA count]; i++)
				if (i <= [c1.DNA count]/5 || i >= 4*[c1.DNA count]/5 )
					[child.DNA replaceObjectAtIndex:i withObject:[c1.DNA objectAtIndex:i]];
				else
					[child.DNA replaceObjectAtIndex:i withObject:[c2.DNA objectAtIndex:i]];
		}
	}
	return child;
}

// генерирует случ. элемент клетки
+ (NSString*) generateRandomNucletoid {
    return [LETTERS substringWithRange: NSMakeRange(arc4random() % LETTERS.length, 1)];
}

// Мутация Х% элементов клетки
- (void)mutate: (int) x {
    // начальные проверки для входных данных
    if (x > 100) x = 100;
    if (x < 0) NSLog(@"Inccorect percent for mutation");
    else { // процесс мутации
        int shot, count = [self.DNA count] * x / 100; // высчитываем количество клеток для мутации в общем случае
        NSString *s;        		
		
        // выбираем случайно Х% клеток, заменяем их значение на lowercase (для сохранения буквы, что бы при замене знать на что менять не надо)
        for (int i = 0; i < count; i++) {
            do {
                shot = arc4random() % [self.DNA count];
                s = [self.DNA objectAtIndex: shot];
            } while (islower([s characterAtIndex: 0]));
            [self.DNA setObject:[s lowercaseString] atIndexedSubscript: shot];
        }
        
        // мутируем все клетки с lowercase
        for (int i = 0; i < [_DNA count]; i++)
            if (islower([[self.DNA objectAtIndex: i] characterAtIndex: 0])) {
                do {
                    s = [Cell generateRandomNucletoid];
                } while ([s isEqual: [[self.DNA objectAtIndex: i] uppercaseString]]);
                [self.DNA setObject: s atIndexedSubscript: i];
            }
    }
}

// печатаем клетку в стандартный поток
-(void) print {
    NSMutableString *s = [NSMutableString string];
    
    for (int i = 0; i < [_DNA count]; i++)
        [s appendString:[_DNA objectAtIndex: i]];
    NSLog(@"%@",s);
}

// описание клетки
-(NSString*) description {
    NSMutableString *s = [NSMutableString string];
    
    for (int i = 0; i < [_DNA count]; i++)
        [s appendString:[_DNA objectAtIndex: i]];
    return s;
}


@end
