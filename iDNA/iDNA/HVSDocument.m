//
//  HVSDocument.m
//  iDNA
//
//  Created by VladIslav Khazov on 23.12.12.
//  Copyright (c) 2012 VladIslav Khazov. All rights reserved.
//

#import "HVSDocument.h"

@implementation HVSDocument

- (id)init
{
    self = [super init];
    if (self) {
        //Создаем популяцию с начальными параметрами.
        myPopulation = [[HVSPopulationOfDna alloc]init];
        //Добавляем свойство lengthDNA в наблюдение нашему контроллеру.
        [myPopulation addObserver:self forKeyPath:@"populationLengthDna" options:NSKeyValueObservingOptionOld context:@"changePopulationLengthDNA"];
        flagPause=NO;
    }
    return self;
}

-(void)dealloc {
    //Убираем свойство lengthDNA из наблюдения.
    [myPopulation removeObserver:self forKeyPath:@"populationLengthDna"];
}

//Метод запускается когда изменяется переменная populationLengthDna объекта myPopulation
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //Проверка, какая переменная была изменена.
    if (context==@"changePopulationLengthDNA") {
        //Получаем текущие значение переменной
        int length = (int)[myPopulation populationLengthDna];
        //Генерим нового Альфа самца 
        [myPopulation setGoalDNA:[[HVSCellDna alloc]initWithLengthDna:length]];
        // Выводим Goal DNA нашей поппуляции в текстовом поле.
        //Берем GOAL DNA
        NSMutableArray *myArrayDNA = [[myPopulation goalDNA] DNA];
        NSMutableString *result = [[NSMutableString alloc]init];
        //Цикл перевода массива в строку.
        for (int i=0; i<=[myArrayDNA count]-1 ; i++) {
            [result appendString:[myArrayDNA objectAtIndex:i]];
        }
        [_popTextGoalDna setStringValue:result];
    }
}

//Действия
-(void)startBackgroundEvolution {
    //Эволюция
    while ([myPopulation flag]==NO && flagPause==NO) {
        [_popLevelMatch setIntegerValue:myPopulation.maxHamming];
        [_popLabelMatch setIntegerValue:myPopulation.maxHamming];
        [_popLabelGeneration setIntegerValue:myPopulation.countEvolution];
        [myPopulation evolution];
    }
    //Меняем интерфейс
    [_popTextSize setEnabled:YES];
    [_popTextLength setEnabled:YES];
    [_popTextRate setEnabled:YES];
    
    [_popSliderSize setEnabled:YES];
    [_popSliderLength setEnabled:YES];
    [_popSliderRate setEnabled:YES];
    
    [_popButtonStart setEnabled:YES];
    [_popButtonLoad setEnabled:YES];
    [_popButtonPause setEnabled:NO];
}


//Нажата кнопка Старт
- (IBAction)buttonStart:(id)sender {
    //Меняем интерфейс
    [_popTextSize setEnabled:NO];
    [_popTextLength setEnabled:NO];
    [_popTextRate setEnabled:NO];
    
    [_popSliderSize setEnabled:NO];
    [_popSliderLength setEnabled:NO];
    [_popSliderRate setEnabled:NO];
    
    [_popButtonStart setEnabled:NO];
    [_popButtonLoad setEnabled:NO];
    [_popButtonPause setEnabled:YES];
    
    //Создаем случайную популяцию ДНК с заданными параметрами.
    [myPopulation setPopulation];
    // Устанавливаем флаг совпадений в NO
    [myPopulation setFlag:NO];
    //Совпадение с Альфа
    [myPopulation setMaxHamming:0];
    //Количество эволюций
    [myPopulation setCountEvolution:0];
    
    //Эволюция - запускаем фоном
    flagPause=NO;
    [self performSelectorInBackground:@selector(startBackgroundEvolution) withObject:nil];
}
- (IBAction)buttonPause:(id)sender {
    flagPause=YES;
    
}
- (IBAction)buttonLoad:(id)sender {
    
}


- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"HVSDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    // Выводим Goal DNA нашей поппуляции.
    //Берем GOAL DNA
    NSMutableArray *myArrayDNA = [[myPopulation goalDNA] DNA];
    NSMutableString *result = [[NSMutableString alloc]init];
    //Цикл перевода массива в строку.
    for (int i=0; i<=[myArrayDNA count]-1 ; i++) {
        [result appendString:[myArrayDNA objectAtIndex:i]];
    }
    [_popTextGoalDna setStringValue:result];
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

@end
