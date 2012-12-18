//
//  Cell.m
//  DNA
//
//  Created by Александр Борунов on 01.11.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//



#import "Cell.h"
#import "Protein.h"



@implementation Cell

// просто создавалка (Protein устанавливается по умолчанию случайно
-(id)initWithDNAlength:(NSInteger)dl{
    self = [super init];
    if (self){
        dnalength = dl;
        chain = [[NSMutableArray alloc] init]; // создали пустую цепочку
        for (int i=0; i < dnalength; i++) { // добавим CHAIN_LENGTH элементов
            [chain addObject:[[Protein alloc]init] ]; // добавили в цепочку вновьсосзданный Protein
        }
    }
    return self;
}

//  этот способ создания не должен использоваться вообще
- (id) init {
    return nil;
}


// создавалка поэлементным копированием. в смысле создаем _новый_ элемент и делаем его таким же как у исходника
- (id) initFromCell: (Cell*)sourceCell{
    self = [super init];
    if (self){
        dnalength = sourceCell->dnalength;

        chain = [[NSMutableArray alloc] init]; // создали пустую цепочку
        for (int i=0; i < dnalength; i++) { // добавим CHAIN_LENGTH элементов
            switch ([[sourceCell->chain objectAtIndex:i] get]) {
                case 'A': { Protein *p =[[Protein alloc]init]; [p setA]; [chain addObject:p]; break; }
                case 'T': { Protein *p =[[Protein alloc]init]; [p setT]; [chain addObject:p]; break; }
                case 'G': { Protein *p =[[Protein alloc]init]; [p setG]; [chain addObject:p]; break; }
                case 'C': { Protein *p =[[Protein alloc]init]; [p setC]; [chain addObject:p]; break; }
            }
        }
    }
    return self;
}

// создавалка из строчки. в смысле создаем _новый_ элемент и делаем его таким же как символ строки
- (id) initFromString: (NSString*)sourceString{
    self = [super init];
    if (self){
        chain = [[NSMutableArray alloc] init]; // создали пустую цепочку
        dnalength = [sourceString length];
        for (int i=0; i < dnalength; i++) { // добавим из строки copyLength элементов
            switch ([sourceString characterAtIndex:i]) {
                case 'A': { Protein *p =[[Protein alloc]init]; [p setA]; [chain addObject:p]; break; }
                case 'T': { Protein *p =[[Protein alloc]init]; [p setT]; [chain addObject:p]; break; }
                case 'G': { Protein *p =[[Protein alloc]init]; [p setG]; [chain addObject:p]; break; }
                case 'C': { Protein *p =[[Protein alloc]init]; [p setC]; [chain addObject:p]; break; }
                default : { Protein *p =[[Protein alloc]init]; [chain addObject:p]; break; } // если не угадал то случайно
            }
        }
    }
    return self;
}





- (int) hammingDistance: (Cell*)comparedCell {
// я понимаю что так итерировать не хорошо. но я правда не знаю как можно
// воспользоваться одним NSEnumerator для двух массивов одинакового размера
    int differences = 0;
    if (self->dnalength != comparedCell->dnalength)return -1; // о чем говорить если длина разная
    for (int i=0; i < dnalength; i++){
        if ( [[self->chain objectAtIndex:i] get] != [[comparedCell->chain objectAtIndex:i] get] ) differences++;
    }
    return differences;
}

- (void) print {
    NSMutableString *result = [NSMutableString string]; // создадим строку куда будем копировать Protein посимвольно
    for (int i=0; i < dnalength; i++){
        char proteinLetter = [[chain objectAtIndex:i] get];  // взяли i-ю букву
        [result appendFormat:@"%c", proteinLetter];          // и добавили к строке
    }
    NSLog(@"%@",result);
}
    
- (NSString*) printToString {
    NSMutableString *result = [NSMutableString string]; // создадим строку куда будем копировать Protein посимвольно
    for (int i=0; i < dnalength; i++){
        char proteinLetter = [[chain objectAtIndex:i] get];  // взяли i-ю букву
        [result appendFormat:@"%c", proteinLetter];          // и добавили к строке
    }
    return result;
}


// проверочка. элемент index устанавливаем в A
- (void) setAinIndex: (int) index {
    [[chain objectAtIndex:index] setA];
}



- (void) mutate: (int) percentageMutations {
    if (percentageMutations > 100) percentageMutations=100; // что бы все работало
    if (percentageMutations < 0) percentageMutations=0;     // на всякий случай
    
    // поймем для начала сколько именно мутаций в штуках надо произвести
    int mutations = percentageMutations * dnalength / 100 ; //  NSLog(@"мутаций будет %i", mutations);
    
    // мутации будем планировать следуюшим образом: создадим массив flag где будем
    // метить те белки которые потом замутируем. сначала массив заполним единицами
    // в количестве запланированных мутаций, а потом этот массив перемешаем как
    // завещал товарищ Кнут в своей второй книге
    
    int flag[dnalength];
    int *p = flag;
    for (int i=0; i<mutations; i++) *p++=1;             // эти мутируют
    for (int i=mutations; i<dnalength; i++) *p++=0;  // а эти сохранятся
    
    // теперь перемешаем массив flag
    for (int i=(int)dnalength-1; i>0; i--) {
        int j = (unsigned int)arc4random()%i; // это тот индекс с которым будем менять i-й элемент
        int temp = flag[i];             // сохраним
        flag[i] = flag[j];              // и
        flag[j] = temp;                 // поменяем местами
    }
    
    // теперь осуществим запланированные мутации
    for (int i=0; i<dnalength; i++)
        if (flag[i]) [[chain objectAtIndex:i] changeRand]; // если белок помечен для мутации вызываем changeRand
    
}

- (id) initFromSex: (Cell*)father With:(Cell*)mother{  // пока реализован тупо дуюлированием отца
    self = [super init];
    if (self){
        dnalength = father->dnalength;
        
        chain = [[NSMutableArray alloc] init]; // создали пустую цепочку
        for (int i=0; i < dnalength; i++) { // добавим CHAIN_LENGTH элементов
            switch ([[father->chain objectAtIndex:i] get]) {
                case 'A': { Protein *p =[[Protein alloc]init]; [p setA]; [chain addObject:p]; break; }
                case 'T': { Protein *p =[[Protein alloc]init]; [p setT]; [chain addObject:p]; break; }
                case 'G': { Protein *p =[[Protein alloc]init]; [p setG]; [chain addObject:p]; break; }
                case 'C': { Protein *p =[[Protein alloc]init]; [p setC]; [chain addObject:p]; break; }
            }
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[self printToString] forKey:@"DNAstring"];
}
-(id)initWithCoder:(NSCoder *)aDecoder {  // на самом деле по лоховски скопировал код из initFromString :(
    if ( self = [super init] ){
        NSString *sourceString = [aDecoder decodeObjectForKey:@"DNAstring"];
        chain = [[NSMutableArray alloc] init]; // создали пустую цепочку
        dnalength = [sourceString length];
        for (int i=0; i < dnalength; i++) { // добавим из строки copyLength элементов
            switch ([sourceString characterAtIndex:i]) {
                case 'A': { Protein *p =[[Protein alloc]init]; [p setA]; [chain addObject:p]; break; }
                case 'T': { Protein *p =[[Protein alloc]init]; [p setT]; [chain addObject:p]; break; }
                case 'G': { Protein *p =[[Protein alloc]init]; [p setG]; [chain addObject:p]; break; }
                case 'C': { Protein *p =[[Protein alloc]init]; [p setC]; [chain addObject:p]; break; }
                default : { Protein *p =[[Protein alloc]init]; [chain addObject:p]; break; } // если не угадал то случайно
            }
        }
    }
    return self;
}

@end

