//
//  Document.m
//  iDNA2
//
//  Created by Evgeny Pozdnyakov on 03.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Document.h"
#import "ui.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        self.populationSize = 1700;
        self.dnaLength = 170;
        self.mutationRate = 17;
        self.evolutionStatus = @"";
        self.evolutionThread = nil;
        self.goalDna = nil;
        self.myPopulation = nil;
        self.generation = 0;
        self.bestCells = 0;
        self.bestMatch = 0;
        self.isReadFromFile = NO;
    }
    return self;
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
    // добавляем наблюдателя за populationSize
    [self addObserver:self 
           forKeyPath:@"populationSize" 
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:&RMDocumentKVOContext];
    // добавляем наблюдателя за dnaLength
    [self addObserver:self 
           forKeyPath:@"dnaLength" 
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:&RMDocumentKVOContext];
    // добавляем наблюдателя за mutationRate
    [self addObserver:self 
           forKeyPath:@"mutationRate" 
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:&RMDocumentKVOContext];
    // добавляем наблюдателя за goalDna
    [self addObserver:self 
           forKeyPath:@"goalDna" 
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:&RMDocumentKVOContext];
    // добавляем наблюдателя за evolutionStatus
    [self addObserver:self 
           forKeyPath:@"evolutionStatus" 
              options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
              context:&RMDocumentKVOContext];
    if (self.goalDna == nil) {
        // генерируем конечную ДНК если ее еще нет
        [self generateGoalDna];
    } else {
        // иначе отображаем ее
        [self displayGoalDna:[self.goalDna description]];
    }
    // в зависимости от текущего статуса меняем блокировку кнопок
    [self resetAppControlsAccordingEvolutionStatus];
    // показываем текущее состояние эволюции
    [self displayEvolutionState];
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    @try {
        Document * doc = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.populationSize = doc.populationSize;
        self.dnaLength = doc.dnaLength;
        self.mutationRate = doc.mutationRate;
        self.goalDna = doc.goalDna;
        self.myPopulation = doc.myPopulation;
        self.evolutionStatus = doc.evolutionStatus;
        self.evolutionThread = nil;
        self.generation = doc.generation;
        self.bestCells = doc.bestCells;
        self.bestMatch = doc.bestMatch;
    }
    @catch (NSException *exception) {
        if (outError) {
            NSDictionary * d = [NSDictionary dictionaryWithObject:@"File is invalid" forKey:NSLocalizedFailureReasonErrorKey];
            * outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
        }
        return NO;
    }
    return YES;
}

- (IBAction)loadGoalDna:(id)sender {
    NSString * fileContent = nil;
    if ([ui openFileDialogAndReadContent:&fileContent]) {
        NSString * newGoalDna = [[fileContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        if (![Cell dnaIsCorrect:newGoalDna]) {
            [ui alertDialogWithTitle:@"Incorrect DNA" 
                             andText:@"File provided doesn't contain a string which can be represented as cell DNA."];
        } else if ([newGoalDna length] < [self.dnaLengthHSldr minValue]) {
            [ui alertDialogWithTitle:@"Short DNA" 
                             andText:[NSString stringWithFormat:@"DNA in the file is too short, it should be at least %lu nu", [self.dnaLengthHSldr minValue]]];
        } else if ([newGoalDna length] > [self.dnaLengthHSldr maxValue]) {
            [ui alertDialogWithTitle:@"Short DNA" 
                             andText:[NSString stringWithFormat:@"DNA in the file is too short, it should be at most %lu nu", [self.dnaLengthHSldr maxValue]]];
        } else {
            self.goalDna = [Cell getCellWithDna:newGoalDna];
            self.dnaLength = self.goalDna.dnaLength;
            [self displayGoalDna:[self.goalDna description]];
        }
    }
}

- (IBAction)startEvolution:(id)sender {
    if (![self.evolutionStatus isEqualToString:@""] && ![self.evolutionStatus isEqualToString:@"finished"]) {
        [NSException raise:@"access to button must be denied" format:@"access to button \"start evolution\" must be denied, because evolutionStatus equal to \"%@\"", self.evolutionStatus];
    }
    self.evolutionStatus = @"started";
}

- (IBAction)pauseEvolution:(id)sender {
    if ([self.evolutionStatus isEqualToString:@"started"] || [self.evolutionStatus isEqualToString:@"resumed"]) {
        self.evolutionStatus = @"paused";
    } else if ([self.evolutionStatus isEqualToString:@"paused"]) {
        self.evolutionStatus = @"resumed";
    } else {
        [NSException raise:@"access to button must be denied" format:@"access to button \"pause\" must be denied, because evolutionStatus equal to \"%@\"", self.evolutionStatus];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object 
                               change:change context:context];
        return;
    }
    NSUndoManager * um = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    NSString * action;
    if ([keyPath isEqualToString:@"populationSize"]) {
        if (oldValue != [NSNull null]) {
            [[um prepareWithInvocationTarget:self] setValue:oldValue forKey:@"populationSize"];
            if (![um isUndoing] && ![um isRedoing]) {
                action = [NSString stringWithFormat:@"change population size to %lu", self.populationSize];
                [um setActionName:action];
            }
        }
    } else if ([keyPath isEqualToString:@"dnaLength"]) {
        // если происходит undo/redo, целевая ДНК будет создана
        // с помощью undo менеджера
        if (![um isUndoing] && ![um isRedoing]) {
            [self generateGoalDna];
        }
    } else if ([keyPath isEqualToString:@"mutationRate"]) {
        if ([self mutationRateIsCorrect]) {
            if (oldValue != [NSNull null]) {
                [[um prepareWithInvocationTarget:self] setValue:oldValue forKey:@"mutationRate"];
                if (![um isUndoing] && ![um isRedoing]) {
                    action = [NSString stringWithFormat:@"change mutation rate to %lu", self.mutationRate];
                    [um setActionName:action];
                }
            }
            self.myPopulation.mutationRate = self.mutationRate;
        } else if (oldValue != [NSNull null]) {
            self.mutationRate = [oldValue integerValue];
            [self.mutationRateHSldr setIntegerValue:self.mutationRate];
            [self.mutationRateTxtFld setIntegerValue:self.mutationRate];
        }
    } else if ([keyPath isEqualToString:@"goalDna"]) {
        if (oldValue != [NSNull null]) {
            [[um prepareWithInvocationTarget:self] setValue:oldValue forKey:@"goalDna"];
            [[um prepareWithInvocationTarget:self] setValue:[NSNumber numberWithInt:[oldValue dnaLength]]
                                                     forKey:@"dnaLength"];
            [[um prepareWithInvocationTarget:self] displayGoalDna:[oldValue description]];
            if (![um isUndoing] && ![um isRedoing]) {
                action = [NSString stringWithFormat:@"change goal dna length to %lu", self.dnaLength];
                [um setActionName:action];
            }
        }
    } else if ([keyPath isEqualToString:@"evolutionStatus"]) {
        if ([self.evolutionStatus isEqualToString:@"started"]) {
            [um removeAllActions];
        } else if ([self.evolutionStatus isEqualToString:@"paused"]) {
            self.myPopulation.evolutionPaused = YES;
        } else if ([self.evolutionStatus isEqualToString:@"resumed"]) {
            self.myPopulation.evolutionPaused = NO;
        }
        [self resetAppControlsAccordingEvolutionStatus];
    }
}

- (void)dealloc {
    if (self.isReadFromFile) {
        // случай когда документ был прочитан из файла и удален за ненадобностью
    } else {
        // удаляем наблюдателей
        [self removeObserver:self forKeyPath:@"populationSize"];
        [self removeObserver:self forKeyPath:@"dnaLength"];
        [self removeObserver:self forKeyPath:@"mutationRate"];
        [self removeObserver:self forKeyPath:@"goalDna"];
        [self removeObserver:self forKeyPath:@"evolutionStatus"];
        // если имелся отдельный процесс с эволюцией, то завершаем его
        if (self.evolutionThread != nil) {
            [self.evolutionThread cancel];
        }
    }
}

- (void)generateGoalDna {
    self.goalDna = [Cell getCellWithDnaLength:self.dnaLength];
    [self displayGoalDna:[self.goalDna description]];
}
             
- (void)displayGoalDna:(NSString *)dna {
    [self.goalDnaTxtVw setString:dna];
}

- (void)displayEvolutionState {
    [self.bestMatchTxtLbl setStringValue:[NSString stringWithFormat:@"%.1f %%", self.bestMatch]];
    [self.bestCellsTxtLbl setIntValue:self.bestCells];
    [self.generationTxtLbl setIntValue:self.generation];
}

- (void)generatePopulation {
    NSDictionary * data;
    data = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:self.populationSize], @"populationSize",
            [NSNumber numberWithInt:self.dnaLength], @"dnaLength",
            [NSNumber numberWithInt:self.mutationRate], @"mutationRate",
            self.goalDna, @"goalDna",
            nil];
    self.myPopulation = [Population createPopulationWithData:data];
}

- (void)resetAppControlsAccordingEvolutionStatus {
    if ([self.evolutionStatus isEqualToString:@""]) {
        [self.pauseBtn setTitle:@"Pause"];
        [self enableAppControls:YES];
    } else if ([self.evolutionStatus isEqualToString:@"started"]) {
        if (self.myPopulation == nil) {
            [self generatePopulation];
        }
        [self.pauseBtn setTitle:@"Pause"];
        [self enableAppControls:NO];
    } else if ([self.evolutionStatus isEqualToString:@"paused"]) {
        [self.pauseBtn setTitle:@"Resume"];
        [self enableAppControls:NO];
    } else if ([self.evolutionStatus isEqualToString:@"resumed"]) {
        [self.pauseBtn setTitle:@"Pause"];
        [self enableAppControls:NO];
    } else if ([self.evolutionStatus isEqualToString:@"finished"]) {
        self.myPopulation = nil;
        [self.evolutionThread cancel];
        self.evolutionThread = nil;
        [self.pauseBtn setTitle:@"Pause"];
        [self enableAppControls:YES];
    }
    // в случае запуска эволюции или снятия с паузы
    // проверяем self.evolutionThread:
    // если он не существует, то создаем и присваиваем ему 
    // отдельный процесс, в котором запускаем runEvolution
    if ([self.evolutionStatus isEqualToString:@"started"] || [self.evolutionStatus isEqualToString:@"resumed"]) {
        if (self.evolutionThread == nil) {
            self.evolutionThread = [[NSThread alloc] initWithTarget:self 
                                                           selector:@selector(runEvolution) 
                                                             object:nil];
            [self.evolutionThread start];
        }
    }
}

- (void)runEvolution {
    NSUInteger steps = 0;
    do {
        NSDictionary * data = [self.myPopulation oneStepEvolution];
        self.bestMatch = [[data objectForKey:@"bestMatch"] floatValue];
        self.bestCells = [[data objectForKey:@"bestCells"] intValue];
        self.generation = [[data objectForKey:@"generation"] intValue];
        [self displayEvolutionState];
        if (self.bestMatch == 100.0) {
            self.evolutionStatus = @"finished";
            break;
        }
    } while (steps++ < 9999);
}

- (void)enableAppControls:(BOOL)status {
    [self.populationSizeTxtFld setEnabled:status];
    [self.populationSizeHSldr setEnabled:status];
    [self.dnaLengthTxtFld setEnabled:status];
    [self.dnaLengthHSldr setEnabled:status];
//    [self.mutationRateTxtFld setEnabled:status];
//    [self.mutationRateHSldr setEnabled:status];
    [self.startEvolutionBtn setEnabled:status];
    [self.pauseBtn setEnabled:!status];
    [self.loadGoalDnaBtn setEnabled:status];
}

- (BOOL)mutationRateIsCorrect {
    NSUInteger numberOfMutation = round(self.dnaLength / 100.0 * self.mutationRate);
    if (numberOfMutation == 0) {
        [ui alertDialogWithTitle:@"Incorrect mutation rate" andText:@"You should increase mutation rate, because it is too small according to DNA length."];
        
        return NO;
    }
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.populationSize forKey:@"populationSize"];
    [aCoder encodeInteger:self.dnaLength forKey:@"dnaLength"];
    [aCoder encodeInteger:self.mutationRate forKey:@"mutationRate"];
    [aCoder encodeObject:self.myPopulation forKey:@"myPopulation"];
    [aCoder encodeObject:self.goalDna forKey:@"goalDna"];
    [aCoder encodeObject:self.evolutionStatus forKey:@"evolutionStatus"];
    [aCoder encodeFloat:self.bestMatch forKey:@"bestMatch"];
    [aCoder encodeInteger:self.bestCells forKey:@"bestCells"];
    [aCoder encodeInteger:self.generation forKey:@"generation"];
    [aCoder encodeBool:YES forKey:@"isReadFromFile"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.populationSize = [aDecoder decodeIntegerForKey:@"populationSize"];
        self.dnaLength = [aDecoder decodeIntegerForKey:@"dnaLength"];
        self.mutationRate = [aDecoder decodeIntegerForKey:@"mutationRate"];
        self.myPopulation = [aDecoder decodeObjectForKey:@"myPopulation"];
        self.goalDna = [aDecoder decodeObjectForKey:@"goalDna"];
        self.evolutionStatus = [aDecoder decodeObjectForKey:@"evolutionStatus"];
        self.bestMatch = [aDecoder decodeFloatForKey:@"bestMatch"];
        self.bestCells = [aDecoder decodeIntegerForKey:@"bestCells"];
        self.generation = [aDecoder decodeIntegerForKey:@"generation"];
        self.isReadFromFile = [aDecoder decodeBoolForKey:@"isReadFromFile"];
    }
    return self;
}

@end
