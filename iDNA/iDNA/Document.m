//
//  Document.m
//  iDNA
//
//  Created by Anatoly Yashkin on 21.12.12.
//  Copyright (c) 2012 Anatoly Yashkin. All rights reserved.
//

#import "Document.h"
#import "Cell.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        //Инициализируем переменные.
        [self setValue:[NSNumber numberWithLong:130] forKey:@"populationSize"];
        [self setValue:[NSNumber numberWithLong:42] forKey:@"dnaLength"];
        [self setValue:[NSNumber numberWithLong:26] forKey:@"mutationRate"];        
        [self setValue:[NSNumber numberWithLong:0] forKey:@"bestMatch"];
        [self setValue:[NSNumber numberWithLong:0] forKey:@"generation"];
        [self setValue:[NSNumber numberWithLong:dnaLength] forKey:@"minHammingDistance"];
        [self setValue:[Cell getRandomDNA:dnaLength] forKey:@"goalDNA"];
        [self setValue:[NSNumber numberWithBool:YES] forKey:@"firstStart"];
        
        //Наблюдаем за некоторыми переменными
        [self addObserver:self forKeyPath:@"dnaLength" options:0 context:@"dnaLengthChanged"];
        [self addObserver:self forKeyPath:@"minHammingDistance" options:0 context:@"minHammingDistanceChanged"];
        [self addObserver:self forKeyPath:@"populationSize" options:0 context:@"populationSizeChanged"];

    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self  forKeyPath:@"dnaLength"];
    [self removeObserver:self  forKeyPath:@"minHammingDistance"];
    [self removeObserver:self  forKeyPath:@"populationSize"];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if (context==@"dnaLengthChanged") {
        //При изменениие длины ДНК, перегененрируем goalDNA и весь процесс начинаем заново
        [self setValue:[Cell getRandomDNA:dnaLength] forKey:@"goalDNA"];
        [self setValue:[NSNumber numberWithBool:YES] forKey:@"firstStart"];
        [self setValue:[NSNumber numberWithLong:0] forKey:@"bestMatch"];
        [self setValue:[NSNumber numberWithLong:dnaLength] forKey:@"minHammingDistance"];
        [self setValue:[NSNumber numberWithLong:0] forKey:@"generation"];
    }
        //при изменении размера популяции весь процесс начинается сначала, но goalDNA НЕ перегенерируется
    else if (context==@"populationSizeChanged"){
        [self setValue:[NSNumber numberWithBool:YES] forKey:@"firstStart"];
        [self setValue:[NSNumber numberWithLong:0] forKey:@"bestMatch"];
        [self setValue:[NSNumber numberWithLong:dnaLength] forKey:@"minHammingDistance"];
        [self setValue:[NSNumber numberWithLong:0] forKey:@"generation"];
    }
    else if (context==@"minHammingDistanceChanged"){
        NSInteger tmpMatch = 100-(100*minHammingDistance/dnaLength);
        if (bestMatch<tmpMatch) {
            [self setValue:[NSNumber numberWithLong:tmpMatch] forKey:@"bestMatch"];
        }
    }
}




-(void)beginEvolution{
    
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"inWork"];
    
    //Генерируем необходимую популяцию ДНК
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:populationSize];
    for (int i=0; i<populationSize; i++) {
        [tmpArr addObject:[Cell getRandomDNA:dnaLength]];
    }
    
    population=tmpArr;
    
    //Пока никто не намет кнопку Pause, будем запускаем метод генерации поколения
    while (inWork) {
        [self performGeneration];
    }
   

}


//Метод генерирует одно поколение
-(void)performGeneration{
 
    //Кривоватый такой инкримент, но, почему-то, если просто написать generator++, то привязка формы к переменной не работат.
    [self setValue:[NSNumber numberWithLong:generation+1] forKey:@"generation"];

    
    //Сортируем популяцию по близости к goalDNA
    [population sortUsingComparator:^(NSString *firstDNA, NSString *secondDNA){
        NSInteger hDistance1 = [Cell hammingDistanceForDna:firstDNA andDNA:goalDNA];
        NSInteger hDistance2 = [Cell hammingDistanceForDna:secondDNA andDNA:goalDNA];
        
        if (hDistance1 < hDistance2)
            return (NSComparisonResult)NSOrderedAscending;
        
        if (hDistance1 > hDistance2)
            return (NSComparisonResult)NSOrderedDescending;
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [self setValue:[NSNumber numberWithLong:[Cell hammingDistanceForDna:[population objectAtIndex:0] andDNA:goalDNA]] forKey:@"minHammingDistance"];
    
    //Проверяем, если нашлась хоть одна ДНК, которая равна goalDNA, то прекращаем эволюцию
    if (minHammingDistance==0) {
        [self setValue:[NSNumber numberWithBool:NO] forKey:@"inWork"];
        return;
    }
    
    //Тут нам нужно будет скрестить ДНК из первых 50% популяции и заменить результами оставшиеся 50%
    //ДНК-гермафродиты допускаются
    
    //Возьмем из первых 50% популяции 2 случайные ДНК
    NSString *randamDNA1=[population objectAtIndex:arc4random_uniform(populationSize/2)];
    NSString *randamDNA2=[population objectAtIndex:arc4random_uniform(populationSize/2)];
    
    
    //Make Love, not war!
    NSString *babyDNA=[Cell makeLoveForDNA:randamDNA1 andDNA:randamDNA2];
    
    //Заменим оставшиемя 50% популяции результатом скрещивания
    for (int i=populationSize/2; i<populationSize; i++) {
        [population replaceObjectAtIndex:i withObject:babyDNA];
    }
    
    //мутируем всю популяцию
    for(int i=0;i<populationSize;i++){
        [population replaceObjectAtIndex:i withObject:[Cell mutateDNA:[population objectAtIndex:i] withPercent:mutationRate]];
    }
    
    

}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.

    
    //Инициализируем значение переменной inWork в этом методе, потому что нам нужено, чтобы все элементы формы успели создаться
    [self setValue:[NSNumber numberWithBool:NO] forKey:@"inWork"];
    
    
    //Заполняем текстовое поле значением переменной goalDNA;
    [_goalDNATF setStringValue:goalDNA];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

-(IBAction)startEvalution:(id)sender{
    
    [self setValue:[NSNumber numberWithBool:NO] forKey:@"firstStart"];
    //стартуем эволюцию в отдельном потоке.
    [self performSelectorInBackground:@selector(beginEvolution) withObject:nil];
    
}

- (IBAction)stopEvolution:(id)sender {
    [self setValue:[NSNumber numberWithBool:NO] forKey:@"inWork"];
}

- (IBAction)loadGoalDNA:(id)sender {
    
    NSLog(@"%@",[Cell mutateDNA:@"ABCABCABCTTTA" withPercent:100]);
}



@end
