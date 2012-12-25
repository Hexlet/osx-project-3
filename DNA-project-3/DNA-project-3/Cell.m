//
//  Cell.m
//  Project1DNK
//
//  Created by Sergey on 02.11.12.
//  Copyright (c) 2012 Sergey. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize hammingDistance;
@synthesize DNA = _DNA;

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
            [_DNA addObject:[arrayATGC objectAtIndex: arc4random() % 4]];
    }
    else if (d < dnaLenght) {
        for (i=dnaLenght-1; i>=d; i--) {
            [_DNA removeObjectAtIndex:i];
        }
    }
    dnaLenght = d;
    if ([_DNA count] != dnaLenght) {
        NSLog(@"длина ДНК различна %lu <> %lu",[_DNA count], dnaLenght );
        
    }
}

-(BOOL)fillDNAString:(NSString*) s {
    NSInteger n = [s length];
    // перебираем переданную строку и ищем запрещенные символы
    for (NSInteger i=0; i<n; i++) {
       unichar charAtIndex = [s characterAtIndex:i];
       NSString* charString = [NSString stringWithCharacters:&charAtIndex length:1];
        if (![arrayATGC containsObject:charString]) {
           NSLog(@"запрещенный символ %@",charString);
           return NO;
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
   return YES;
}

-(int) calculateHammingDistance:(Cell*) c {
    int counthammingDistance = 0;
    for ( int i=0; i<dnaLenght; i++) {
        if ([[_DNA objectAtIndex:i] isEqualToString: [c.DNA objectAtIndex: i]]) {
           counthammingDistance ++;
        }
    }
    hammingDistance = counthammingDistance;
    return counthammingDistance;
}

-(void)mutate:(NSInteger) percent {
    NSMutableArray* mutateCell = [[NSMutableArray alloc] init];
    NSNumber* num = [NSNumber alloc];
    int x = percent*dnaLenght/100;
    int num_int, num_int2;
    for (int i=1; i<=x; i++) {
        num_int = arc4random() % dnaLenght;
        while ([mutateCell containsObject:[num initWithInt:num_int]]==YES) {
            //           NSLog(@"уже менялась ячейка %i",num_int);
            num_int = arc4random() % dnaLenght;
        }
        [mutateCell addObject:[num initWithInt:num_int]];
        //       NSLog(@"меняем %i раз, ячейку %i",i,num_int);
        num_int2 = arc4random() % 4;
        while ([[self.DNA objectAtIndex:num_int] isEqualToString:[arrayATGC objectAtIndex:num_int2]] == YES)  {
            //       NSLog(@"совпало в ячейке %i",num_int2);
            num_int2 = arc4random() % 4;
        }
        [self.DNA replaceObjectAtIndex:num_int withObject:[arrayATGC objectAtIndex:num_int2]];
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
    if (num_variant == 1) {
         //50% первого ДНК + 50% второго ДНК
        int halfdnaLenght = dnaLenght/2; //50%
        for(int i=0; i<dnaLenght; i++) {
            if ((i+1)<halfdnaLenght)
                [NewDNA addObject:[_DNA objectAtIndex:i]];
            else
                [NewDNA addObject:[c.DNA objectAtIndex:i]];
        }
     }
     else if (num_variant == 2) {
         //1% первого ДНК + 1% второго ДНК + 1% первого ДНК + ... и т.д.
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


@end
