//
//  Document.m
//  iDNA
//
//  Created by Stas on 12/26/12.
//  Copyright (c) 2012 Stas. All rights reserved.
//

#import "Document.h"
#import "Cell.h"
#import "ResultController.h"

#define PRINT_DNAS          for (int count = 0; count < controlPopSize; count++)                    \
                            NSLog(@"DNA: %@, HD = %i", [[population objectAtIndex:count] print],    \
                            [goalDna hammingDistance:[population objectAtIndex:count]]);            \
                            NSLog(@" ");

@implementation Document

Cell *goalDna;                  // внешняя, чтобы все методы могли с ней работать.
int countOfGeneration = 1;      // делаем эту переменную внешней, чтобы к ней можно было дотянуться из окна NSPanel
ResultController *resultWindow;
//NSInteger NSRunAlertPanel (NSString *title, NSString *msg, NSString *defaultButton, NSString *alternateButton);

- (id)init
{
    if (self = [super init]) {
        // Add your subclass-specific initialization here. 
        controlPopSize   = 1000;        // задаем
        controlDnaLength = 20;          // начальное положение
        controlMutRate   = 10;          // ползунков
        [self addObserver:self forKeyPath:@"controlPopSize"   options:NSKeyValueObservingOptionOld context:@"PopSizeChanged"];    // наблюдаем
        [self addObserver:self forKeyPath:@"controlDnaLength" options:NSKeyValueObservingOptionOld context:@"DnaLengthChanged"];  // за
        [self addObserver:self forKeyPath:@"controlMutRate"   options:NSKeyValueObservingOptionOld context:@"MutRateChanged"];    // ключами
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"controlPopSize"];
    [self removeObserver:self forKeyPath:@"controlDnaLength"];
    [self removeObserver:self forKeyPath:@"controlMutRate"];
}

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue {
    [obj setValue:newValue forKey:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    NSUndoManager * undo = [self undoManager];

    if (context == @"PopSizeChanged" || context == @"MutRateChanged")
        [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    
    if (context == @"DnaLengthChanged") {
        [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
        [Cell setDnaLength:(int)controlDnaLength];
        [goalDna addRemoveElements:(int)controlDnaLength];
        [tfMonitor setStringValue:[goalDna print]];
    }
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [super windowControllerDidLoadNib:aController];
    [pauseDisplay setEnabled:NO];
    [Cell setDnaLength:(int)controlDnaLength];
    goalDna = [[Cell alloc]init];
    [tfMonitor setStringValue:[goalDna print]];
}

+ (BOOL)autosavesInPlace {
    return NO;
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

- (IBAction)startEvolution:(id)sender {
    [self performSelectorInBackground:@selector(beginEvolution) withObject:nil];
}

- (IBAction)pause:(id)sender {
    if (!pauseFlag) {
        pauseFlag = YES;
        [pauseDisplay setTitle:@"Continue"];
    }
    else {
        pauseFlag = NO;
        [pauseDisplay setTitle:@"Pause"];
    }
}

- (void) beginEvolution {
    [startEvolutionDisplay setEnabled:NO];
    [tfPopSizeDisplay setEnabled:NO];
    [tfDnaLengthDisplay setEnabled:NO];
    [sliPopSizeDisplay setEnabled:NO];
    [sliDnaLengthDisplay setEnabled:NO];
    [pauseDisplay setEnabled:YES];
    [loadDisplay setEnabled:NO];
    [saveDisplay setEnabled:NO];
    NSMutableArray *population = [[NSMutableArray alloc] initWithCapacity:controlPopSize];
    NSMutableArray *sortPopulation = [[NSMutableArray alloc] initWithCapacity:controlPopSize];
    int bestMatchHdGen, bestMatchHdPop = 0;
    
    // процесс заполнения популяции особями
    for (int popCount = 0; popCount < controlPopSize; popCount++)
        [population addObject:[[Cell alloc] init]];

    /*
    SLog(@"Generation 0:");
     PRINT_DNAS
    */
    
    while (YES) {                           // зацикливаем цикл. условие выхода (проверка совпадения с Goal DNA) реализуем в теле
        if (!pauseFlag) {                   // выполняем цикл, пока не нажата кнопка Pause
            // процесс сортировки
            for (int dnaCount = 0; dnaCount <= controlDnaLength; dnaCount++)
                for (int count = 0; count < controlPopSize; count++)
                    if ([goalDna hammingDistance:[population objectAtIndex:count]] == dnaCount)
                        [sortPopulation addObject:[population objectAtIndex:count]];
    
            [population removeAllObjects];
            [population addObjectsFromArray:sortPopulation];
            [sortPopulation removeAllObjects];
    
            /*
             NSLog(@"After sorting:");
             PRINT_DNAS
             */
    
            [lbgeneration setIntegerValue:countOfGeneration];
        
            // проверка: создана ли особь, совпадающая с Goal DNA
            if (![goalDna hammingDistance:[population objectAtIndex:0]]) {      // проверяем по hammingDistance
                resultWindow = [[ResultController alloc] init];                 // ... если создана, то инициализируем и...
                [resultWindow showWindow:self];                                 // ... вызывем окно результата
                [piBestMatchHdGen setDoubleValue:100];                          // ... если создана, то ползунок должен показывать 100%
                [piBestMatchHdPop setDoubleValue:100];                          // ... если создана, то ползунок должен показывать 100%
                break;                                                          // ... если создана, то выходим
            }
    
            // процесс скрещивания
            for (int count = (controlPopSize + 1) / 2; count < controlPopSize; count++) {   // пробегаемся по второй половине популяции (с неудачными особями)
                int indexOfPap = arc4random() % controlPopSize / 2;                         // выбираем папу из диапазона удачных особей
                int indexOfMom = arc4random() % controlPopSize / 2;                         // выбираем маму из того-же диапазона. ничего страшного, если совпадут
                [[population objectAtIndex:count] papsexwith:                               // рождаем из неудачных особей
                 [population objectAtIndex:indexOfPap] momsex:                              // с помощью папы и мамы
                 [population objectAtIndex:indexOfMom]];                                    // новую более удачливую особь
            }
        
            /*
             NSLog(@"After sex:");
             PRINT_DNAS
             */
    
            // процесс мутации
            for (int count = 0; count < controlPopSize; count++)                            // процесс мутации беспощаден. он касается ВСЕХ!
                [[population objectAtIndex:count] mutate:(int)controlMutRate];              // собственно мутация
    
            // процесс подсчета bestMatchHd
            for (int count = 1; count < controlPopSize; count++)
                if ([goalDna hammingDistance:[population objectAtIndex:count - 1]] < [goalDna hammingDistance:[population objectAtIndex:count]])
                    bestMatchHdGen = [goalDna hammingDistance:[population objectAtIndex:count - 1]];
    
            /*
            NSLog(@"After mutation:");
            PRINT_DNAS
            */
    
            bestMatchHdGen = (bestMatchHdGen * 100 / controlDnaLength - 100) * -1;  // пересчет bestMatchHdGen в диапазон [0...100] для корректного отображения в NSProgressIndicator
            if (bestMatchHdGen > bestMatchHdPop)
                bestMatchHdPop = bestMatchHdGen;
    
            [piBestMatchHdGen setDoubleValue:(float)bestMatchHdGen];
            [piBestMatchHdPop setDoubleValue:(float)bestMatchHdPop];
        
            countOfGeneration++;
        }
    }
    [startEvolutionDisplay setEnabled:YES];
    [tfPopSizeDisplay setEnabled:YES];
    [tfDnaLengthDisplay setEnabled:YES];
    [sliPopSizeDisplay setEnabled:YES];
    [sliDnaLengthDisplay setEnabled:YES];
    [pauseDisplay setEnabled:NO];
    [loadDisplay setEnabled:YES];
    [saveDisplay setEnabled:YES];
    
    countOfGeneration = 1;
}

-(IBAction)saveGoalDna:(id)sender { // сохранение целевой ДНК в текстовый файл
    NSSavePanel *dnaSavePanel = [NSSavePanel savePanel];
    NSInteger res = [dnaSavePanel runModal];
    if (res == NSOKButton) {
        NSURL *url = [dnaSavePanel URL];
        NSString *s = [self->tfMonitor stringValue];
        [s writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

-(IBAction)loadGoalDna:(id)sender { // загрузка целевой ДНК из текстового файла
    NSOpenPanel *dnaOpenPanel = [NSOpenPanel openPanel];
    NSInteger res = [dnaOpenPanel runModal];
    if (res == NSOKButton) {
        NSURL *url = [dnaOpenPanel URL];
        NSString *s = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        if (controlDnaLength == [s length]) {           // если длины загружаемой и целевой GoalDNA совпадают, то...
            [goalDna cellFromString:s];                 // изменяем GoalDNA загружаемой...
            [tfMonitor setStringValue:[goalDna print]]; // ...и показываем
        }
        else {                                          // если нет, то вызываем окно с ошибкой
            NSAlert *alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Length of loaded GoalDNA must be %ld elements", controlDnaLength];
            [alert beginSheetModalForWindow:[tfMonitor window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
        }
     }
}

@end
