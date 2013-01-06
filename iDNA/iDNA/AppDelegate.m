//
//  AppDelegate.m
//  iDNA
//
//  Created by Alexander Shvets on 24.12.12.
//  Copyright (c) 2012 Alexander Shvets. All rights reserved.
//

#import "AppDelegate.h"
#import "Nucleotides.h"
#import "IntegerValueFormatter.h"

#define MAX_POPULATION_SIZE 5000
#define DEFAULT_POPULATION_SIZE 1000
#define MAX_DNA_LENGTH 300
#define DEFAULT_DNA_LENGTH 50
#define DEFAULT_MUTATION_RATE 10

#define APP_STATE_IDLE 0
#define APP_STATE_RUNNING 1
#define APP_STATE_PAUSED 2

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [self appReset];
    
    IntegerValueFormatter* formatter = [[IntegerValueFormatter alloc] init];
    [_fieldPopulationSize setFormatter:formatter];
    [_fieldDNALength setFormatter:formatter];
    [_fieldMutationRate setFormatter:formatter];
    
    [_sliderPopulationSize setMaxValue:MAX_POPULATION_SIZE];
    [_sliderDNALength setMaxValue:MAX_DNA_LENGTH];
    [self setPopulationSize:DEFAULT_POPULATION_SIZE];
    [self setDNALength:DEFAULT_DNA_LENGTH];
    [self setMutationRate:DEFAULT_MUTATION_RATE];
    
    [_fieldGoalDNA setStringValue:[goalDNA stringValue]];
    
    [_labelGeneration setStringValue:[NSString stringWithFormat:@"Generation: %i", generation]];
}

- (id)init
{
    if(self = [super init]){
        [self addObserver:self forKeyPath:@"populationSize" options:NSKeyValueObservingOptionOld context:@"populationSize"];
        [self addObserver:self forKeyPath:@"DNALength" options:NSKeyValueObservingOptionOld context:@"DNALength"];
        [self addObserver:self forKeyPath:@"mutationRate" options:NSKeyValueObservingOptionOld context:@"mutationRate"];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"populationSize"];
    [self removeObserver:self forKeyPath:@"DNALength"];
    [self removeObserver:self forKeyPath:@"mutationRate"];
}

- (void)appReset
{
    appState = APP_STATE_IDLE;
    generation = 1;
    bestMatch = 0;
    
    [self enableControls];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == @"populationSize") {
        
        if(populationSize > MAX_POPULATION_SIZE){
            populationSize = MAX_POPULATION_SIZE;
            [_fieldPopulationSize setIntegerValue:populationSize];
        } else if(populationSize < 2){
            populationSize = 2;
            [_fieldPopulationSize setIntegerValue:populationSize];
        }
        
        //NSLog(@"populationSize %i", populationSize);
        
    } else if (context == @"DNALength") {
        
        if(DNALength > MAX_DNA_LENGTH){
            DNALength = MAX_DNA_LENGTH;
            [_fieldDNALength setIntegerValue:DNALength];
        } else if(DNALength < 1){
            DNALength = 1;
            [_fieldDNALength setIntegerValue:DNALength];
        }
        
        [self buildGoalDNAWithLength: DNALength];
        //NSLog(@"DNALength %i", DNALength);

    } else if (context == @"mutationRate") {
        
        if(mutationRate < 1){
            mutationRate = 1;
            [_fieldMutationRate setIntValue:mutationRate];
        } else if(mutationRate > 100){
            mutationRate = 100;
            [_fieldMutationRate setIntValue:mutationRate];
        }
        
        //NSLog(@"mutationRate $i", mutationRate);
    }    
}

- (void)setPopulationSize:(int)size
{
    populationSize = size;
}

- (void)setDNALength:(int)length
{
    DNALength = length;
}

- (void)setMutationRate:(int)rate
{
    mutationRate = rate;
}

- (void)buildGoalDNAWithLength:(int) length
{
    goalDNA = [[Cell alloc] initWithLength:length];
    [_fieldGoalDNA setStringValue:[goalDNA stringValue]];
}


- (IBAction)startEvolution:(id)sender {
    [self disableControls];
    
    if(appState != APP_STATE_PAUSED){
        population = [[Population alloc] initWithPopulationSize:populationSize andDNALength:DNALength];
        NSLog(@"New population created. Simulation started.");
    } else {
        NSLog(@"Simulation continue");
    }
    
    //NSLog(@"goal: %@, %i", [goalDNA stringValue], DNALength);
    
    appState = APP_STATE_RUNNING;
    
    //start background evolution
    NSThread* bgEvolutionThread = [[NSThread alloc] initWithTarget:self selector:@selector(evolution) object:nil];
    [bgEvolutionThread start];
}

- (void) evolution
{
    
    do {
        @autoreleasepool { //устраняем утечку памяти в цикле
            
            // пересчитать расстояние Хэминга для каждой клетки в популяции
            [population hammingDistanceWith:goalDNA];
            
            // отсортировать популяцию по расстоянию Хэминга
            [population sort];
            
            // процент сходства лучшей клетки с целевой ДНК
            float bestPopulationDistance = DNALength - [[population.cells objectAtIndex:0] hammingDistance];
            float matchPercent = (bestPopulationDistance / DNALength) * 100;
            
            // обновление статистики (если необходимо)
            if((int)matchPercent > bestMatch){
                bestMatch = (int)matchPercent;
                [_progressMatch setIntValue:bestMatch];
                [_labelBestMatch setStringValue:[NSString stringWithFormat:@"Best individual match: %i%%", bestMatch]];
                
                NSLog(@"\nNew best match: %i%% \nBest DNA: %@", bestMatch, [[population.cells objectAtIndex:0] stringValue]);
            }
             
            // проверка на успешное завершение эволюции
            if(![population evolutionSuccess]){
                
                // скрестить кандидатов из топ 50% и заменить результатом оставшиеся 50%
                if(DNALength >= 2) [population hybridize];
                
                // мутировать получившуюся популяцию
                [population mutate:mutationRate];
                
                generation++;
                [_labelGeneration setStringValue:[NSString stringWithFormat:@"Generation: %i", generation]];
                
            } else { // эволюция завершена
                
                [_labelBestMatch setStringValue:@"Simulation successfully complete."];
                NSLog(@"JOB DONE!!!!");
                NSBeep();
                
                appState = APP_STATE_IDLE;
                [self appReset];
            }
            
        }
    } while(appState == APP_STATE_RUNNING);
    
}

- (IBAction)pauseEvolution:(id)sender {
    if([[sender title] isEqualToString:@"Pause"]){
        //pause
        appState = APP_STATE_PAUSED;
        [sender setTitle:@"Resume"];
        
    } else {
        //resume
        [self startEvolution:nil];
        [sender setTitle:@"Pause"];
    }
}

- (void)disableControls
{
    [_fieldPopulationSize setEnabled:NO];
    [_fieldDNALength setEnabled:NO];
    [_sliderPopulationSize setEnabled:NO];
    [_sliderDNALength setEnabled:NO];
    [_btnStart setEnabled:NO];
    [_btnLoad setEnabled:NO];
    [_btnPause setEnabled:YES];
}

- (void)enableControls
{
    [_fieldPopulationSize setEnabled:YES];
    [_fieldDNALength setEnabled:YES];
    [_sliderPopulationSize setEnabled:YES];
    [_sliderDNALength setEnabled:YES];
    [_btnStart setEnabled:YES];
    [_btnLoad setEnabled:YES];
    [_btnPause setEnabled:NO];
}

- (IBAction)loadGoalDNA:(id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"txt", @"dna", nil]];
    [openDlg setAllowsMultipleSelection:NO];
    
    if([openDlg runModal] == NSOKButton){
        NSArray* files = [openDlg URLs];
        NSString* filePath = [[files objectAtIndex:0] path];
        
        if(filePath){
            NSString* fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            NSString* dnaString = [self validateDNAString:fileContents];
            NSLog(@"File DNA: %@", dnaString);
            
            if([dnaString length]){
                [self setDNALength:(int)[dnaString length]];
                [_fieldGoalDNA setStringValue:dnaString];
                
                //goalDNA = nil;
                goalDNA = [[Cell alloc ] initWithString:dnaString];
                NSLog(@"Loaded goal DNA: %@", [goalDNA stringValue]);
                
            } else {
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setMessageText:@"\nWrong DNA format.\nNo nucleotides found."];
                [alert beginSheetModalForWindow:_window modalDelegate:self didEndSelector:nil contextInfo:nil];
            }
            
        }
    }
    
}

// проверка загруженой из файла ДНК.
// удаление неправильных символов (не C,G,T,A). это позволяет скормить приложению любой текстовый файл.
// обрезать ДНК до максимально возможной длины
- (NSString*)validateDNAString:(NSString*)DNAString
{

    NSArray* nucleotides = [[Nucleotides sharedInstance] getNucleotides];
    NSString* dnaString = @"";
    NSString* singleChar = @"";
    
    for(int i = 0; i < [DNAString length]; i++){
        singleChar = [[DNAString substringWithRange:NSMakeRange(i,1)] uppercaseString];
        if([nucleotides containsObject:singleChar]){
            dnaString = [dnaString stringByAppendingString:singleChar];
        }
        
        if([dnaString length] >= MAX_DNA_LENGTH) break;
    }
    
    return dnaString;
}

// закрываем приложение при закрытии окна
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end