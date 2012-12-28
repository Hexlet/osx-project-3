//
//  AppDelegate.m
//  DNA-project-3
//
//  Created by Sergey on 22.12.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Cell.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize goalDNATextField;
@synthesize pauseButton;
@synthesize startButton;
@synthesize loadButton;
@synthesize populationSizeTextField;
@synthesize dnaLengthTextField;
@synthesize mutationRateTextField;
@synthesize populationSizeSlider;
@synthesize dnaLengthSlider;
@synthesize mutationRateSlider;

@synthesize generationTextField;
@synthesize bestMatchTextField;

static void *RMDocumentKVOContext;

- (NSUndoManager*) windowWillReturnUndoManager: (NSWindow*) window {
    return undoManager;
}

-(void) changeKeyPath:(NSString*)keyPath ofObject:(id)obj toValue:(id)newValue {
    [obj setValue:newValue forKeyPath:keyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldValue == [NSNull null])
        oldValue = nil;
    [[undoManager prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    [undoManager setActionName:@"Edit"];
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"populationSize"];
    [self removeObserver:self forKeyPath:@"dnaLength"];
    [self removeObserver:self forKeyPath:@"mutationRate"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //NSLog(@"applicationDidFinishLaunching");
    [goalDNATextField setStringValue:[goalDNA stringDNA]];
}

-(void)setPopulationSize:(NSInteger) x {
//    NSLog(@"setPopulationSize");
        /*1. создать случайную популяцию ДНК. Размер популяции = значение первого text field'а.
     Размер каждого ДНК = значение второго text field'а.*/
    NSInteger i;
    if (x > populationSize) {
        for (i=populationSize; i<x; i++) {
            Cell* myCell = [[Cell alloc] init]; // добавляем нужное количество
            [myCell fillDNALenght:dnaLength];
            [population addObject:myCell];
        }
    }
    else if (x < populationSize) {
        for (i=populationSize-1; i>=x; i--)
            [population removeObjectAtIndex:i]; // удаляем лишние элементы
    }
    populationSize = x;
}

-(NSInteger)populationSize  {
    return populationSize;
}

-(void)setDnaLength:(NSInteger) x {
    dnaLength = x;
    // обновляем goalDNA
    [goalDNA fillDNALenght:dnaLength];    
    [goalDNATextField setStringValue:[goalDNA stringDNA]];
    //обновляем DNA в популяции
    for (int i=0; i<populationSize; i++)
        [[population objectAtIndex:i] fillDNALenght:dnaLength];
}

-(NSInteger)dnaLength{
    return dnaLength;
}

-(void)setMutationRate:(NSInteger) x {
    mutationRate = x;    
}

-(NSInteger)mutationRate {
    return mutationRate;
}

-(void)setGeneration:(int) x {
    generation = x;
}

-(NSInteger)generation {
    return generation;
}

-(void)setBestHammingDistance:(NSInteger)x {
    bestHammingDistance = x;
}

-(NSInteger)bestHammingDistance {
    return bestHammingDistance;
}

-(void)setVisible:(BOOL) v {
    [populationSizeTextField setEnabled:!v];
    [dnaLengthTextField setEnabled:!v];
    [mutationRateTextField setEnabled:!v];
    
    [populationSizeSlider setEnabled:!v];
    [dnaLengthSlider setEnabled:!v];
    [mutationRateSlider setEnabled:!v];
    
    [loadButton setEnabled:!v];
    [startButton setEnabled:!v];
    
     //3. сделать активной кнопку Pause.
    [pauseButton setEnabled:v];
}

-(void)processEvolution{
    /*2. сделать неактивными (disabled) три первых text field'а и их ползунки,
     а также кнопки "Start evolution" и "Load goal DNA"*/
    [self setVisible:evolution=YES];
    
    [self willChangeValueForKey:@"generation"];
    generation = 0; // установили счетчик генераций
    [self didChangeValueForKey:@"generation"];

    /*4. начать эволюцию.*/
    while (evolution == YES) {
        [self willChangeValueForKey:@"generation"];
        generation++;
        [self didChangeValueForKey:@"generation"];
        //4.1 Отсортировать популяцию по близости (hamming distance) к Goal DNA
        // вычисляем различия hammingDistance чтобы по нему отсортировать
        for (int i=0; i<populationSize; i++) {
            [[population objectAtIndex:i] calculateHammingDistance:goalDNA];
        }
        // сортируем объекты с массиве population по значению  hammingDistance
        // создаем объект класса NSSortDescriptor, который будет использоваться для сортировки
        NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hammingDistance" ascending:YES comparator:^(id obj1, id obj2) {
        
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        // непостредственно сортируем массив, используя ранее созданные десктрипторы
        NSMutableArray* sortedArray = [NSMutableArray arrayWithArray:[population sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]] ];
        [population removeAllObjects];
        [population addObjectsFromArray:sortedArray];

        //4.2 Остановить эволюцию если есть ДНК полностью совпадающее с Goal DNA (hamming distance = 0)
        // вычисляем различия hammingDistance чтобы по нему отсортировать
        [self willChangeValueForKey:@"bestHammingDistance"];
        bestHammingDistance = 100 - [[population objectAtIndex:0] hammingDistance];
        [self didChangeValueForKey:@"bestHammingDistance"];
        
        if (bestHammingDistance == 100) {
            [self setVisible:evolution=NO];
            return;
        }
        //4.3 Скрестить кандидатов из топ 50% и заменить результатом оставшиеся 50%.
        //4.3.1 Взять два случайных ДНК
        for (int i=populationSize/2; i<populationSize; i++) {
            int num_int1 = arc4random() % (populationSize / 2);  // 1 из топ 50%
            int num_int2 = arc4random() % (populationSize / 2);  // 2 из топ 50%
            // смотрим чтобы ячейки не совпали
            while (num_int1 == num_int2)
                num_int2 = arc4random() % (populationSize / 2);  // 2 из топ 50%
            //4.3.2 Скомбинировать их содержание чтобы получить новую ДНК.
            NSMutableArray* NewDNA = [[NSMutableArray alloc]init];
            NewDNA = [[population objectAtIndex:num_int1] crossing:[population objectAtIndex:num_int2]];
            [[[population objectAtIndex:i] DNA] removeAllObjects];
            [[[population objectAtIndex:i] DNA] addObjectsFromArray:NewDNA];
        }
    
        //4.4 Мутировать популяцию (как в проекте 1) используя значение процента мутирования из третьего text field'а.
        for (int i=0; i<populationSize; i++)
            [[population objectAtIndex:i] mutate:mutationRate];
    
    }
}

- (IBAction)startEvolution:(id)sender {
    if ([[goalDNA DNA] count] != dnaLength) {
        NSMutableString *message = [NSMutableString string];
        [message appendFormat:@"The length of the goal DNA %lu and the population DNA %lu are not equal !",[[goalDNA DNA] count], dnaLength];
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:message];
        [alert setInformativeText:@"Change the size of the DNA population or download another target DNA"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
        return;
    }
    [self performSelectorInBackground:@selector(processEvolution) withObject:nil];//стартуем новый поток
  }

- (IBAction)pauseEvolution:(id)sender {
    //Эволюция идет пока не нажата кнопка Pause ИЛИ пока не достигнута цель эволюции.
    [self setVisible:evolution=NO];
}

- (IBAction)loadGoalDNA:(id)sender {
    NSMutableString *message = [NSMutableString string];
    NSURL *filePath;
    NSOpenPanel *fileBrowser = [NSOpenPanel openPanel];
    [fileBrowser setCanChooseFiles:YES];
    [fileBrowser setCanChooseDirectories:YES];
    if ([fileBrowser runModal] == NSOKButton) {
        NSArray *files = [fileBrowser URLs];
        for ( int i = 0; i < [files count]; i++ ) {
            filePath = [files objectAtIndex:i];
            NSString *fileContents = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
            NSInteger maxDNAlenght = MAXDNALENGTH;
            if ([fileContents length]>maxDNAlenght) {
                [message appendFormat:@"The downloadable file exceeds maximum length of DNA = %lu !", maxDNAlenght];
                NSAlert *alert = [[NSAlert alloc] init];
                [alert addButtonWithTitle:@"OK"];
                [alert setMessageText:message];
                [alert setInformativeText:@"Select the file with the correct structure of DNA"];
                [alert setAlertStyle:NSWarningAlertStyle];
                [alert runModal];
                return;
            }
            NSString *s =  [goalDNA fillDNAString:fileContents];
            if (s == @"") {
                [goalDNATextField setStringValue:fileContents];
            }
            else {
                [message appendFormat:@"The downloadable file is invalid character = %@ !", s];
                NSAlert *alert = [[NSAlert alloc] init];
                [alert addButtonWithTitle:@"OK"];
                [alert setMessageText:message];
                [alert setInformativeText:@"Select the file with the correct structure of DNA"];
                [alert setAlertStyle:NSWarningAlertStyle];
                [alert runModal];
            }
        }
    }
}

-(id)init {
    self = [super init];
    if (self) {
        population = [[NSMutableArray alloc] init];
        undoManager = [[NSUndoManager alloc] init];
        evolution = NO;
        
        [self willChangeValueForKey:@"populationSize"];
        populationSize = DEFAULTPOPULATIONSIZE;
        [self didChangeValueForKey:@"populationSize"];
        
        [self willChangeValueForKey:@"dnaLength"];
        dnaLength = DEFAULTDNALENGTH;
        [self didChangeValueForKey:@"dnaLength"];
        
        [self willChangeValueForKey:@"mutationRate"];
        mutationRate = DEFAULTMUTATIONRATE;
        [self didChangeValueForKey:@"mutationRate"];
        
        [self willChangeValueForKey:@"generation"];
        generation = 0;
        [self didChangeValueForKey:@"generation"];
        
        goalDNA = [[Cell alloc] init ];
        [goalDNA fillDNALenght:dnaLength];
        
        // заполняем новыми популяциями
        for (int i=0; i<populationSize; i++) {
            Cell* myCell = [[Cell alloc] init];
            [myCell fillDNALenght:dnaLength];
            [population addObject:myCell];
         }
        [self addObserver:self forKeyPath:@"populationSize" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
        [self addObserver:self forKeyPath:@"dnaLength" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
        [self addObserver:self forKeyPath:@"mutationRate" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    }
    return self;
}

- (IBAction)savePopulation:(id)sender {
    NSSavePanel *savingDialog = [NSSavePanel savePanel];
    
    [savingDialog setAllowedFileTypes:[NSArray arrayWithObject:@"dna"]];
    if ([savingDialog runModal] == NSOKButton) {
        NSMutableData *data = [NSMutableData data];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:population forKey:@"populationKey"];
        [archiver encodeObject:goalDNA forKey:@"goalDNAKey"];
        [archiver encodeInteger:populationSize forKey:@"populationSizeKey"];
        [archiver encodeInteger:dnaLength forKey:@"dnaLengthKey"];
        [archiver encodeInteger:mutationRate forKey:@"mutationRateKey"];
        [archiver finishEncoding];
        [data writeToURL:[savingDialog URL] atomically:YES];
    }
}

- (IBAction)loadPopulation:(id)sender {
    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"dna", @"DNA", nil];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:fileTypes];
    if ([openPanel runModal] == NSOKButton) {
        NSURL *archiveURL = [[openPanel URLs] objectAtIndex:0];
        NSData *data = [NSData dataWithContentsOfURL:archiveURL];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        
        population = [unarchiver decodeObjectForKey:@"populationKey"];
        
        goalDNA = [unarchiver decodeObjectForKey:@"goalDNAKey"];
        [goalDNATextField setStringValue:[goalDNA stringDNA]];
            
        [self willChangeValueForKey:@"populationSize"];
        populationSize = [unarchiver decodeIntegerForKey:@"populationSizeKey"];
        [self didChangeValueForKey:@"populationSize"];
            
        [self willChangeValueForKey:@"dnaLength"];
        dnaLength = [unarchiver decodeIntegerForKey:@"dnaLengthKey"];
        [self didChangeValueForKey:@"dnaLength"];
            
        [self willChangeValueForKey:@"mutationRate"];
        mutationRate = [unarchiver decodeIntegerForKey:@"mutationRateKey"];
        [self didChangeValueForKey:@"mutationRate"];
            
        [unarchiver finishDecoding];
    }
}

@end
