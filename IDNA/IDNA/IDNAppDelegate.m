//
//  IDNAppDelegate.m
//  IDNA
//
//  Created by Dmitriy Zhukov on 06.01.13.
//  Copyright (c) 2013 Dmitriy Zhukov. All rights reserved.
//

#import "IDNAppDelegate.h"
#import "IDNCell.h"
#import "IDNPopulation.h"

@implementation IDNAppDelegate

-(id)init {
    self = [super init];
    if (self) {
        self.populationSize=1000;
        self.DNALength=10;
        self.mutationRate=10;
        self.generationCount=0;
        self.progress=0;
        self.distanceToTargetDNA=0;
        self.interfaceStatement = true;
        self.startStatement = true;
        self.stopEvolutionFlag = true;
        self.pauseEvolutionFlag = true;
        self.pauseStatement = false;
        
    }
    return self;
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"DNALength"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.workingPopulation = [[IDNPopulation alloc] init]; //возможно исключить
    
    self.goalDNA = [[IDNCell alloc]init];
    [self.goalDNA fillDNAArrayWithCapacity:self.DNALength];
    [self.goalDNAField setStringValue:[self.goalDNA.DNA componentsJoinedByString:@""]];
    [self addObserver:self forKeyPath:@"DNALength" options:NSKeyValueObservingOptionOld context:@"DNALengthContext"];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != @"DNALengthContext") {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    [self.goalDNA fillDNAArrayWithCapacity:self.DNALength];
    [self.goalDNAField setStringValue:[self.goalDNA.DNA componentsJoinedByString:@""]];
}


#pragma mark
#pragma mark - pause/run/reset

- (IBAction)startEvolution:(id)sender {
    self.interfaceStatement = false;
    self.startStatement = false;
    self.pauseStatement = true;
    self.stopEvolutionFlag = false;
    self.pauseEvolutionFlag = false;
    if ([self.workingPopulation.population count]==0) { //Проверяем не пустой ли массив. Если пустой содаем рабочий.
        [self.workingPopulation createPopulationWithCount:_populationSize andDNALength:_DNALength];
    }
    [self performSelectorInBackground:@selector(evolution) withObject:nil];
}

- (IBAction)pauseEvolution:(id)sender {
    self.pauseEvolutionFlag = true;
    self.startStatement = true;
    self.pauseStatement = false;
    
}

- (IBAction)stopEvolution:(id)sender {
    self.stopEvolutionFlag = true;
}

- (void)resetInterface {
    self.stopEvolutionFlag = true;
    self.pauseEvolutionFlag = true;
    self.interfaceStatement = true;
    self.startStatement = true;
    self.pauseStatement = false;
    IDNPopulation *newPopulation = [[IDNPopulation alloc]init];
    self.workingPopulation = newPopulation;
    self.generationCount = 0;
    self.distanceToTargetDNA = 0;
    self.progress = 0;
    
}


#pragma mark
#pragma mark - UpgradeInterface

- (void)upgradeInterface {
    self.generationCount = self.workingPopulation.generationNumber;
    self.distanceToTargetDNA = self.workingPopulation.bestDNADistanseInPopulation;
    self.progress = self.workingPopulation.progressToTarget;
}

#pragma mark
#pragma mark - Evolution

- (void) evolution {
       for (;;) {
       if (self.pauseEvolutionFlag) {
       break;
       } else if (self.stopEvolutionFlag){
       [self performSelectorOnMainThread:@selector(resetInterface) withObject:nil waitUntilDone:YES];
        break;
       }
       else {
       [self.workingPopulation sortPopulationByHummingDistanceTo:self.goalDNA]; //первый этап
           if (self.workingPopulation.bestDNADistanseInPopulation == 0) {//Если присутствует идеальное днк - прекращаем эволюцию.
       
            [self performSelectorOnMainThread:@selector(upgradeInterface) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(modalArlertCall) withObject:nil waitUntilDone:YES]; //Вызываем модальное окно.
            [self performSelectorOnMainThread:@selector(resetInterface) withObject:nil waitUntilDone:YES]; //Сбрасываем интерфейс
           
            break;
           } else {
               
               [self.workingPopulation crossingBestDNA];//Второй этап
               [self.workingPopulation populationMutate: self.mutationRate];//Третий этап
               [self performSelectorOnMainThread:@selector(upgradeInterface) withObject:nil waitUntilDone:YES];
    
}
}
}
}

#pragma mark
#pragma mark - load/save method

- (IBAction)loadDNAfromFile:(id)sender {
    NSOpenPanel* newOpenPanel = [NSOpenPanel openPanel];
    [newOpenPanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
    
    [newOpenPanel setAllowsOtherFileTypes:NO];
    NSInteger result = [newOpenPanel runModal];
    
    if (result == NSOKButton)
    { //do something
        
        NSString *selectedFile = [[newOpenPanel URL] path];
        NSError* error = nil;
        
        NSString*newGoalDnaString = [NSString stringWithContentsOfFile:selectedFile
                                                    encoding:NSUTF8StringEncoding
                                                    error:&error];
        
        if (error != nil) {
            [self modalArlertCantOpenFile:[error localizedDescription]];
            return;
        }
        
        NSCharacterSet* checkingSet = [[NSCharacterSet characterSetWithCharactersInString:@"ATGC"]invertedSet];
        
        if ([newGoalDnaString rangeOfCharacterFromSet:checkingSet].location != NSNotFound)
        {
            [self modalArlertCantOpenFile:@"Format of DATA is not wrang. Currectly like this: 'ATGCCGAATGTT'"];
        } else if (newGoalDnaString.length !=self.DNALength) {
            
            NSString *allertMessege = [NSString stringWithFormat:@"Wrong DNA long. Change it to %li",newGoalDnaString.length];
            [self modalArlertCantOpenFile:allertMessege];
        } else {
        
            NSMutableArray* myArray = [[NSMutableArray alloc]initWithCapacity:newGoalDnaString.length];
            
            for (int i=0; i < newGoalDnaString.length; i++) {
                NSString *ichar  = [NSString stringWithFormat:@"%C", [newGoalDnaString characterAtIndex:i]];
                [myArray addObject:ichar];
            }
        IDNCell *newGoalDNA= [[IDNCell alloc]init];
        newGoalDNA.arrayCapacity = [myArray count];
        newGoalDNA.DNA = myArray;
        self.goalDNA = newGoalDNA;
        [self.goalDNAField setStringValue:[self.goalDNA.DNA componentsJoinedByString:@""]];
}
}
}

- (IBAction)saveData:(id)sender {
    NSSavePanel *newSavePanel	= [NSSavePanel savePanel];
    [newSavePanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
    [newSavePanel setAllowsOtherFileTypes:NO];
    NSInteger result = [newSavePanel runModal];
    
    if (result == NSOKButton)
    {
        NSString *selectedFile = [[newSavePanel URL] path];
        NSString *arrayComplete = [self.goalDNA.DNA componentsJoinedByString:@""];
        
        NSError* error =nil;
        
        [arrayComplete writeToFile:selectedFile
                        atomically:NO
                          encoding:NSUTF8StringEncoding
                             error:&error];
        if (error != nil) {
            [self modalArlertCantSaveFile:[error localizedDescription]];
        }
    }
}

#pragma mark
#pragma mark - modalAlert

- (void)modalArlertCall {
    NSAlert *alertFindDNA = [NSAlert alertWithMessageText:@"Find ideal DNA" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Generation left:%lu", self.workingPopulation.generationNumber];
    [alertFindDNA runModal];
}

- (void)modalArlertCantSaveFile:(NSString*)Problem {
    NSAlert *alertFindDNA = [NSAlert alertWithMessageText:@"Can't save file" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", Problem];
    [alertFindDNA runModal];
}

- (void)modalArlertCantOpenFile:(NSString*)Problem {
    NSAlert *alertFindDNA = [NSAlert alertWithMessageText:@"Can't open file" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", Problem];
    [alertFindDNA runModal];
}

@end
