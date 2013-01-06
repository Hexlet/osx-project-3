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
@synthesize generationTxtLbl = _generationTxtLbl;
@synthesize bestMatchTxtLbl = _bestMatchTxtLbl;
@synthesize bestCellsTxtLbl = _bestCellsTxtLbl;

@synthesize populationSize = _populationSize;
@synthesize dnaLength = _dnaLength;
@synthesize mutationRate = _mutationRate;
@synthesize myPopulation = _myPopulation;
@synthesize goalDna = _goalDna;
@synthesize evolutionStatus = _evolutionStatus;
@synthesize evolutionThread = _evolutionThread;

@synthesize populationSizeTxtFld = _populationSizeTxtFld;
@synthesize populationSizeHSldr = _populationSizeHSldr;
@synthesize dnaLengthTxtFld = _dnaLengthTxtFld;
@synthesize dnaLengthHSldr = _dnaLengthHSldr;
@synthesize mutationRateTxtFld = _mutationRateTxtFld;
@synthesize mutationRateHSldr = _mutationRateHSldr;
@synthesize goalDnaTxtVw = _goalDnaTxtVw;

@synthesize loadGoalDnaBtn = _loadGoalDnaBtn;
@synthesize startEvolutionBtn = _startEvolutionBtn;
@synthesize pauseBtn = _pauseBtn;


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
        [self displayGoalDna:[_goalDna description]];
    }
    // в зависимости от текущего статуса меняем блокировку кнопок
    [self resetAppControlsAccordingEvolutionStatus];
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
        } else if ([newGoalDna length] < [_dnaLengthHSldr minValue]) {
            [ui alertDialogWithTitle:@"Short DNA" 
                             andText:[NSString stringWithFormat:@"DNA in the file is too short, it should be at least %lu nu", [_dnaLengthHSldr minValue]]];
        } else if ([newGoalDna length] > [_dnaLengthHSldr maxValue]) {
            [ui alertDialogWithTitle:@"Short DNA" 
                             andText:[NSString stringWithFormat:@"DNA in the file is too short, it should be at most %lu nu", [_dnaLengthHSldr maxValue]]];
        } else {
            self.goalDna = [Cell getCellWithDna:newGoalDna];
            self.dnaLength = _goalDna.dnaLength;
            [self displayGoalDna:[_goalDna description]];
        }
    }
}

- (IBAction)startEvolution:(id)sender {
    if (![_evolutionStatus isEqualToString:@""] && ![_evolutionStatus isEqualToString:@"finished"]) {
        [NSException raise:@"access to button must be denied" format:@"access to button \"start evolution\" must be denied, because evolutionStatus equal to \"%@\"", self.evolutionStatus];
    }
    self.evolutionStatus = @"started";
}

- (IBAction)pauseEvolution:(id)sender {
    if ([_evolutionStatus isEqualToString:@"started"] || [_evolutionStatus isEqualToString:@"resumed"]) {
        self.evolutionStatus = @"paused";
    } else if ([_evolutionStatus isEqualToString:@"paused"]) {
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
        if (oldValue != [NSNull null]) {
            [[um prepareWithInvocationTarget:self] setValue:oldValue forKey:@"mutationRate"];
            if (![um isUndoing] && ![um isRedoing]) {
                action = [NSString stringWithFormat:@"change mutation rate to %lu", self.mutationRate];
                [um setActionName:action];
            }
        }
        _myPopulation.mutationRate = self.mutationRate;
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
        if ([_evolutionStatus isEqualToString:@"started"]) {
            [um removeAllActions];
        } else if ([_evolutionStatus isEqualToString:@"paused"]) {
            _myPopulation.evolutionPaused = YES;
        } else if ([_evolutionStatus isEqualToString:@"resumed"]) {
            _myPopulation.evolutionPaused = NO;
        }
        [self resetAppControlsAccordingEvolutionStatus];
    }
}

- (void)dealloc {
    if (self.evolutionThread != nil) {
        [_evolutionThread cancel];
    }
    @try {
        [self removeObserver:self forKeyPath:@"populationSize"];
        [self removeObserver:self forKeyPath:@"dnaLength"];
        [self removeObserver:self forKeyPath:@"mutationRate"];
        [self removeObserver:self forKeyPath:@"goalDna"];
        [self removeObserver:self forKeyPath:@"evolutionStatus"];
    }
    @catch (NSException *exception) {
        NSLog(@"cannot remove observers in dealloc");
    }
}

- (void)generateGoalDna {
    self.goalDna = [Cell getCellWithDnaLength:self.dnaLength];
    [self displayGoalDna:[_goalDna description]];
}
             
- (void)displayGoalDna:(NSString *)dna {
    [_goalDnaTxtVw setString:dna];
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
    if ([_evolutionStatus isEqualToString:@""]) {
        [_pauseBtn setTitle:@"Pause"];
        [self enableAppControls:YES];
    } else if ([_evolutionStatus isEqualToString:@"started"]) {
        if (self.myPopulation == nil) {
            [self generatePopulation];
        }
        [_pauseBtn setTitle:@"Pause"];
        [self enableAppControls:NO];
    } else if ([_evolutionStatus isEqualToString:@"paused"]) {
        [_pauseBtn setTitle:@"Resume"];
        [self enableAppControls:NO];
    } else if ([_evolutionStatus isEqualToString:@"resumed"]) {
        [_pauseBtn setTitle:@"Pause"];
        [self enableAppControls:NO];
    } else if ([_evolutionStatus isEqualToString:@"finished"]) {
        self.myPopulation = nil;
        [_evolutionThread cancel];
        self.evolutionThread = nil;
        [_pauseBtn setTitle:@"Pause"];
        [self enableAppControls:YES];
    }
    // в случае запуска эволюции или снятия с паузы
    // проверяем self.evolutionThread:
    // если он не существует, то создаем и присваиваем ему 
    // отдельный процесс, в котором запускаем runEvolution
    if ([_evolutionStatus isEqualToString:@"started"] || [_evolutionStatus isEqualToString:@"resumed"]) {
        if (self.evolutionThread == nil) {
            self.evolutionThread = [[NSThread alloc] initWithTarget:self 
                                                           selector:@selector(runEvolution) 
                                                             object:nil];
            [_evolutionThread start];
        }
    }
}

- (void)runEvolution {
    NSUInteger steps = 0;
    do {
        NSDictionary * data = [_myPopulation oneStepEvolution];
        float bestMatch = [[data objectForKey:@"bestMatch"] floatValue];
        NSString * bestMatchStr = [NSString stringWithFormat:@"%.1f %%", bestMatch];
        @try {
            [_bestMatchTxtLbl setStringValue:bestMatchStr];
        }
        @catch (NSException *exception) {
            NSLog(@"can't display best match value: %@", bestMatchStr);
        }
        NSUInteger bestCells = [[data objectForKey:@"bestCells"] intValue];
        @try {
            [_bestCellsTxtLbl setIntValue:bestCells];
        }
        @catch (NSException *exception) {
            NSLog(@"can't display best cells value: %lu", bestCells);
        }
        NSUInteger generation = [[data objectForKey:@"generation"] intValue];
        @try {
            [_generationTxtLbl setIntValue:generation];
        }
        @catch (NSException *exception) {
            NSLog(@"can't display generation value: %lu", generation);
        }
        if (bestMatch == 100.0) {
            self.evolutionStatus = @"finished";
            break;
        }
    } while (steps++ < 9999);
}

- (void)enableAppControls:(BOOL)status {
    [_populationSizeTxtFld setEnabled:status];
    [_populationSizeHSldr setEnabled:status];
    [_dnaLengthTxtFld setEnabled:status];
    [_dnaLengthHSldr setEnabled:status];
//    [_mutationRateTxtFld setEnabled:status];
//    [_mutationRateHSldr setEnabled:status];
    [_startEvolutionBtn setEnabled:status];
    [_pauseBtn setEnabled:!status];
    [_loadGoalDnaBtn setEnabled:status];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.populationSize forKey:@"populationSize"];
    [aCoder encodeInteger:self.dnaLength forKey:@"dnaLength"];
    [aCoder encodeInteger:self.mutationRate forKey:@"mutationRate"];
    [aCoder encodeObject:self.myPopulation forKey:@"myPopulation"];
    [aCoder encodeObject:self.goalDna forKey:@"goalDna"];
    [aCoder encodeObject:self.evolutionStatus forKey:@"evolutionStatus"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.populationSize = [aDecoder decodeIntegerForKey:@"populationSize"];
        self.dnaLength = [aDecoder decodeIntegerForKey:@"dnaLength"];
        self.mutationRate = [aDecoder decodeIntegerForKey:@"mutationRate"];
        self.myPopulation = [aDecoder decodeObjectForKey:@"myPopulation"];
        self.goalDna = [aDecoder decodeObjectForKey:@"goalDna"];
        self.evolutionStatus = [aDecoder decodeObjectForKey:@"evolutionStatus"];
    }
    return self;
}

@end
