//
//  Document.m
//  iDNA
//
//  Created by Александр Борунов on 13.12.12.
//  Copyright (c) 2012 Александр Борунов. All rights reserved.
//

#import "Document.h"


static void *RMDocumentKVOContext;

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        // сейчас я просто установлю значения по умолчанию, а связку с визуальными формами сделаю позже
        dnaLength = 10;
        mutationRate = 12;
        populationSize = 100;
        bestMatchPercent = 0;
        generation = 0;
        
        goalDNA = [Evolution getRandomDNAWithLength:dnaLength];
        
        disabledWhenIncorrectDNA = nil;
        disabledWhenEvolution = nil;
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
    
    // а здесь значения не даем (они уже пришли либо из init либо из файла) только сообщаем на первый раз экранным формам
    [_fieldDNALength setIntValue:(int)dnaLength];
    [_fieldMutationRate setIntValue:(int)mutationRate];
    [_fieldPopulationSize setIntValue:(int)populationSize];
    [_fieldBestMatch setIntValue:(int)bestMatchPercent];
    [_indicatorBestMatch setIntValue:(int)bestMatchPercent];
    [_fieldGoalDNA setStringValue:goalDNA];

    disabledWhenIncorrectDNA = [NSArray arrayWithObjects:   _fieldPopulationSize,
                                                            _fieldDNALength,
                                                            _fieldMutationRate,
                                                            _sliderPopulationSize,
                                                            _sliderDNALength,
                                                            _sliderMutationRate,
                                                            _buttonStart,
                                                            _buttonPause, nil];
    disabledWhenEvolution = [NSArray arrayWithObjects:   _fieldPopulationSize,
                                _fieldDNALength,
                                _fieldMutationRate,
                                _sliderPopulationSize,
                                _sliderDNALength,
                                _sliderMutationRate,
                                _buttonStart,
                                _buttonLoad, nil];
    [_fieldIsDNAcorrect setStringValue:@""];
    
    // последим за нашими переменными
    [self addObserver:self forKeyPath:kPopulationSize options:NSKeyValueObservingOptionOld context:& RMDocumentKVOContext];
    [self addObserver:self forKeyPath:kDNALength options:NSKeyValueObservingOptionOld context:& RMDocumentKVOContext];
    [self addObserver:self forKeyPath:kMutationRate options:NSKeyValueObservingOptionOld context:& RMDocumentKVOContext];
    
    
}

+ (BOOL)autosavesInPlace
{
    return YES;
}




- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // код нагло взят из документации из проекта iSpend
    
    if ([typeName isEqualToString:iDNADocumentType]) {
        NSData *data;
        NSMutableDictionary *doc = [NSMutableDictionary dictionary];
        NSString *errorString;
        
        [doc setObject:[NSNumber numberWithInteger:populationSize] forKey:kPopulationSize];
        [doc setObject:[NSNumber numberWithInteger:dnaLength] forKey:kDNALength];
        [doc setObject:[NSNumber numberWithInteger:mutationRate] forKey:kMutationRate];
        [doc setObject:goalDNA forKey:kGoalDNA];
        
        data = [NSPropertyListSerialization dataFromPropertyList:doc format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
        if (!data) {
            if (!outError) {
                NSLog(@"dataFromPropertyList failed with %@", errorString);
            } else {
                NSDictionary *errorUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"iDNA document couldn't be written", NSLocalizedDescriptionKey, (errorString ? errorString : @"An unknown error occured."), NSLocalizedFailureReasonErrorKey, nil];
                
                // In this simple example we know that no one's going to be paying attention to the domain and code that we use here.
                *outError = [NSError errorWithDomain:@"iDNAErrorDomain" code:-1 userInfo:errorUserInfo];
            }
        }
        return data;
    } else {
        if (outError) *outError = [NSError errorWithDomain:@"iDNAErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Unsupported data type: %@", typeName] forKey:NSLocalizedFailureReasonErrorKey]];
    }
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // код нагло взят из документации из проекта iSpend
    BOOL result = NO;
    // we only recognize one data type.  It is a programming error to call this method with any other typeName
    assert([typeName isEqualToString:iDNADocumentType]);
    
    NSString *errorString;
    NSDictionary *documentDictionary = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:&errorString];
    
    if (documentDictionary) {
        populationSize = (int)[[documentDictionary objectForKey:kPopulationSize] integerValue];
        dnaLength = (int)[[documentDictionary objectForKey:kDNALength] integerValue];
        mutationRate = (int)[[documentDictionary objectForKey:kMutationRate] integerValue];
        goalDNA = [documentDictionary objectForKey:kGoalDNA];
         
        result = YES;
    } else {
        if (!outError) {
            NSLog(@"propertyListFromData failed with %@", errorString);
        } else {
            NSDictionary *errorUserInfo = [NSDictionary dictionaryWithObjectsAndKeys: @"iDNA document couldn't be read", NSLocalizedDescriptionKey, (errorString ? errorString : @"An unknown error occured."), NSLocalizedFailureReasonErrorKey, nil];
            
            *outError = [NSError errorWithDomain:@"iDNAErrorDomain" code:-1 userInfo:errorUserInfo];
        }
        result = NO;
    }
    // we don't want any of the operations involved in loading the new document to mark it as dirty, nor should they be undo-able, so clear the undo stack
    // [[self undoManager] removeAllActions];
    return result;
}


// эти три пары методов нам нужны для связки слайдеров, переменных в классе и соответствующих text fields
-(void)setPopulationSize:(int)pSize {
    populationSize = pSize;
    [_fieldPopulationSize setIntValue:pSize];
}
-(NSInteger)populationSize{
    return populationSize;
}
-(void)setDnaLength:(int)dl {
    dnaLength = dl;
    [_fieldDNALength setIntValue:dl];
    goalDNA = [Evolution getRandomDNAWithLength:dnaLength];
    [_fieldGoalDNA setStringValue:goalDNA];
    
}
-(NSInteger)dnaLengh{
    return dnaLength;
}
-(void)setMutationRate:(int)mr {
    mutationRate = mr;
    [_fieldMutationRate setIntValue:mr];
}
-(NSInteger)mutationRate{
    return mutationRate;
}


// этот метод устанавливает изображение расстояния наилучшей клетки от идеала
-(void)setBestMatchPercent:(int)pc {
    if ( pc < 0 ) pc = 0;
    if ( pc > 100 ) pc = 100;
    [_fieldBestMatch setIntValue:pc];
    [_indicatorBestMatch setIntValue:pc];
    bestMatchPercent = pc;
}
-(NSInteger)bestMatchPercent {
    return bestMatchPercent;
}

// когда пользоатель вводит ручками строчку ДНК нужно проверить что бы он не написал не тех символов
// и если что не так, не выпустим его из этого поля пока не одумается
- (IBAction)validateDNA:(id)sender {
    // обозначим что все хорошо
    BOOL state = YES;
    goalDNA = [_fieldGoalDNA stringValue];
    [_fieldIsDNAcorrect setStringValue:@""];
    NSUInteger l = [goalDNA length];
    if ( l != dnaLength ) {
        state = NO;
        [_fieldIsDNAcorrect setStringValue:[NSString stringWithFormat:@"incorrect chain length: must be %lu, current is %lu",dnaLength,l]];
    }
    else {
        if ( ![Evolution isValidDNAString:goalDNA] ){
            state = NO;
            [_fieldIsDNAcorrect setStringValue:@"incorrect chain symbols: must be ACTG"];
        }
        
    }
    for (id i in disabledWhenIncorrectDNA){
        [i setEnabled:state];
    }
        
}



// что особенно приятно в хорошем коде, так это то что его можно использовать неоднократно
// организация undo/redo скопипащена целиком у Рахима и ничего не изменив оно работает

-(void) changeKeyPath: (NSString*)keyPath ofObject: (id)obj toValue:(id)newValue {
    [obj setValue:newValue forKeyPath:keyPath];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ( context != &RMDocumentKVOContext ) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if ( oldValue == [NSNull null]) {
        oldValue = nil;
    }
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    if (![undo isUndoing]){
        [undo setActionName:@"Edit"];
    }
    
    
}




@end
