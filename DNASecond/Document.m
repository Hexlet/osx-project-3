//
//  Document.m
//  DNASecond
//
//  Created by Tsyganov Stanislav on 23.12.12.
//  Copyright (c) 2012 Tsyganov Stanislav. All rights reserved.
//

#import "Document.h"


@implementation Document

//@synthesize popSize = _popSize;

- (id)init
{
    self = [super init];
    if (self) {
//        NSLog(@"init");
        // Add your subclass-specific initialization here.
        [self setValue:[NSNumber numberWithInt:20] forKey:@"popSize"];
        [self setValue:[NSNumber numberWithInt:10] forKey:@"dnaLength"];
        [self setValue:[NSNumber numberWithInt:10] forKey:@"mutRateSize"];
        [self addObserver:self forKeyPath:@"self.dnaLength" options:NSKeyValueObservingOptionNew context:nil];
        
//        _perfectCell = [[Cell alloc] initWithLength:_dnaLength];
        _stringForPerfectCell = [Cell stringForPrfectCellDNAWithLength:_dnaLength];
//        [_perfectCellTextField setTitle:[NSString stringWithFormat:@"%@", _perfectCell]];
//        [_perfectCellTextField setTitle:@"abc"];
//        NSLog(@"%@", _stringForPerfectCell);
//        NSLog(@"value %ld", _popSize);
//        _popSize
//        _mutRateSize = 50;
//        NSLog(@"value %@");
        _generation = 0;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"self.dnaLength"]) {
//        NSLog(@"%ld", _dnaLength);
        _stringForPerfectCell = [Cell stringForPrfectCellDNAWithLength:_dnaLength];
//        NSLog(@"%@", _stringForPerfectCell);
        [_perfectCellTextField setTitle:_stringForPerfectCell];
    }
}

- (NSString *)windowNibName
{
    NSLog(@"windowNibName");
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.

}

+ (BOOL)autosavesInPlace
{
    NSLog(@"autosavesInPlace");
    return NO;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"dataOfType");
//    [[table window] endEditingFor:nil];
    
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    NSArray* arcDict = @[@1, @2, @3];
////    NSDictionary* arcDict = @{
////        @"abc":@"abc"
////    
////    };
//    
//    return [NSKeyedArchiver archivedDataWithRootObject:_dnasArray];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"readFromData");
    NSMutableArray *unArcDict = nil;
    @try {
        unArcDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"unArcDict %@", unArcDict);
    }
    @catch (NSException *e) {
        if (outError) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The file is invalid" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
            return NO;
        }
    }
    NSLog(@"%@", unArcDict);
    return YES;
}

- (IBAction)startEvolution:(id)sender {
    [_strtEvolutionBtn setEnabled:NO];
    [_pauseEvolutionBtn setEnabled:YES];
//    [_loadDNAButton setEnabled:NO];
    [_popSizeTextField setEnabled:NO];
    [_dnaLengthTextField setEnabled:NO];
    [_popSizeSlider setEnabled:NO];
    [_dnaLengthSlider setEnabled:NO];
//    _generation = 0;
    [self performSelectorInBackground:@selector(createDNAsArray) withObject:nil];
    
    [self setEvolutionStopped:NO];
    
//    [self setValue:[NSNumber numberWithBool:NO] forKey:@"stopEv"];
//    [self createDNAsArray];
}

- (IBAction)stopEvolution:(id)sender {
    [_strtEvolutionBtn setEnabled:YES];
    [_pauseEvolutionBtn setEnabled:NO];
//    [_loadDNAButton setEnabled:YES];
    [_popSizeTextField setEnabled:YES];
    [_dnaLengthTextField setEnabled:YES];
    [_popSizeSlider setEnabled:YES];
    [_dnaLengthSlider setEnabled:YES];
    [self setEvolutionStopped:YES];
    [_generationLabel setStringValue:[NSString stringWithFormat:@"%ld", _generation]];
    
    double progress = 100. - (double)[[_dnasArray objectAtIndex:0] hammingDistanceToString:_stringForPerfectCell] * 100 / _dnaLength;
    
    
    [_bestMatchLabel setStringValue:[NSString stringWithFormat:@"%.2f",progress]];
    
    [_progressIndicator setDoubleValue:progress];
    
    double sum = 0;
    for (int i = 0; i < _popSize; i++) {
        sum += [[_dnasArray objectAtIndex:i] hammingDistanceToString:_stringForPerfectCell];
    }
    double avgHam = sum / _popSize;
    //    NSLog(@"%.2f", avgHam);
    [_averageHammingDistLabel setStringValue:[NSString stringWithFormat:@"%f", avgHam]];
    NSLog(@"generation: %ld, %f", _generation, avgHam);
    
    
    _generation = 0;
//    _dnasArray = nil;
}

-(void)createDNAsArray{
    _generation = 0;
    _dnasArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _popSize; i++) {
        Cell* simpleCell = [[Cell alloc] initWithLength:_dnaLength];
//        NSLog(@"%@", simpleCell);
//        [_dnasDict setObject:simpleCell forKey:[simpleCell hammingDistanceToString:_stringForPerfectCell]];
        
        [_dnasArray addObject:simpleCell];
        
//        [_dnasDict setObject:[NSNumber numberWithInt:[simpleCell hammingDistanceToString:_stringForPerfectCell]] forKey:@"distance"];
//        [_dnasDict setObject:simpleCell forKey:@"cell"];
    }
    
    NSLog(@"%@", _dnasArray);
//    _dnasArray
    [_dnasArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int hm1 = [(Cell*)obj1 hammingDistanceToString:_stringForPerfectCell];
        int hm2 = [(Cell*)obj2 hammingDistanceToString:_stringForPerfectCell];
        if (hm1 < hm2)
            return NSOrderedAscending;
        else if (hm1 > hm2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
//    NSLog(@"%@", _dnasArray);
    for (int i = 0; i < _popSize; i++) {
//        NSLog(@"%@ %d", [_dnasArray objectAtIndex:i], [[_dnasArray objectAtIndex:i] hammingDistanceToString:_stringForPerfectCell]);
    }

    [self evolutionStep];
}



-(void)evolutionStep{
    //  take best part
    NSRange theRange;
    theRange.location = 0;
    theRange.length = [_dnasArray count] / 2;
    NSArray* bestArr = [NSArray arrayWithArray:[_dnasArray subarrayWithRange:theRange]];
//    NSLog(@"best arr %@", bestArr);
    
    //  create new second part of DNAs
    int lengthOfFirstPart = [_dnasArray count] / 2;
    int lengthOfSecondPart = [_dnasArray count] - lengthOfFirstPart;
    
    for (int j = 0; j < lengthOfSecondPart; j++) {
        int firstNum = arc4random_uniform(lengthOfFirstPart);
        int secondNum = arc4random_uniform(lengthOfFirstPart);
//        NSLog(@"first/second: %d/%d", firstNum, secondNum);
        Cell* newCell = [[Cell alloc] initCellFromFirst:[_dnasArray objectAtIndex:firstNum] andSecond:[_dnasArray objectAtIndex:secondNum]];
        [_dnasArray setObject:newCell atIndexedSubscript:lengthOfFirstPart + j];
    }
    
//    NSLog(@"new array: %@", _dnasArray);
    
//    NSLog(@"mut");
    
    
    //check before mutation
    
    if([self matchGoalCheck]){
        NSLog(@"Scores!!! GOAAAAALLLL!!!! Brilliant, brilliant!! I'll just end it all!!!");
        [self performSelectorOnMainThread:@selector(stopEvolution:) withObject:nil waitUntilDone:NO];
        return;
    }
    
    
    //  mutate now
    for (int i = 0; i < _popSize; i++) {
        [[_dnasArray objectAtIndex:i] mutate:_mutRateSize];
    }
//    NSLog(@"after mutate: %@", _dnasArray);
    
//    NSLog(@"sort");
    //  sort array
    [_dnasArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int hm1 = [(Cell*)obj1 hammingDistanceToString:_stringForPerfectCell];
        int hm2 = [(Cell*)obj2 hammingDistanceToString:_stringForPerfectCell];
        if (hm1 < hm2)
            return NSOrderedAscending;
        else if (hm1 > hm2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];    
    
    if([self matchGoalCheck]){
        NSLog(@"Scores!!! GOAAAAALLLL!!!! Brilliant, brilliant!! I'll just end it all!!!");
//        [self stopEvolution:nil];
        [self performSelectorOnMainThread:@selector(stopEvolution:) withObject:nil waitUntilDone:NO];
    }else{
//        NSLog(@"next Step");
//        [self evolutionStep];
        [self performSelectorOnMainThread:@selector(startNextStep) withObject:nil waitUntilDone:NO];
    }
}

-(void)startNextStep{
    
    
    if (!_evolutionStopped) {
        [self updateUI];
        [self performSelectorInBackground:@selector(evolutionStep) withObject:nil];
    }else{
        NSLog(@"Evolution stopped");
    }
    
//    [self evolutionStep];
}

-(void)updateUI{
    //  update UI
    _generation++;
    [_generationLabel setStringValue:[NSString stringWithFormat:@"%ld", _generation]];
//    [_bestMatchLabel setStringValue:[NSString stringWithFormat:@"%@",[_dnasArray objectAtIndex:0]]];
    
    //update avg generation every 10-th time
    if (_generation % 10 != 0) {
        return;
    }
    
    double progress = 100. - (double)[[_dnasArray objectAtIndex:0] hammingDistanceToString:_stringForPerfectCell] * 100 / _dnaLength;
    
//    NSLog(@"%d", [[_dnasArray objectAtIndex:0] hammingDistanceToString:_stringForPerfectCell]);
//    NSLog(@"%d", [[_dnasArray objectAtIndex:0] hammingDistanceToString:_stringForPerfectCell] / _dnaLength);
//    NSLog(@"%d", [[_dnasArray objectAtIndex:0] hammingDistanceToString:_stringForPerfectCell] + 1 * 100 / _dnaLength);
    
    [_progressIndicator setDoubleValue:progress];
    [_bestMatchLabel setStringValue:[NSString stringWithFormat:@"%.2f",progress]];
    
    
    double sum = 0;
    for (int i = 0; i < _popSize; i++) {
        sum += [[_dnasArray objectAtIndex:i] hammingDistanceToString:_stringForPerfectCell];
    }
    double avgHam = sum / _popSize;
    //    NSLog(@"%.2f", avgHam);
    [_averageHammingDistLabel setStringValue:[NSString stringWithFormat:@"%f", avgHam]];
    NSLog(@"generation: %ld, %f", _generation, avgHam);
}

-(BOOL)matchGoalCheck{
    Cell* alphaDNA = [_dnasArray objectAtIndex:0];
    if ([alphaDNA hammingDistanceToString:_stringForPerfectCell] == 0) {
        return YES;
    }
    return NO;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSLog(@"encodeWithCoder");
    [aCoder encodeInteger:_popSize forKey:@"popSize"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"initWithCOder");
    if (self = [super init]) {
        _popSize = [aDecoder decodeIntegerForKey:@"popSize"];
    }
    return self;
}

@end
