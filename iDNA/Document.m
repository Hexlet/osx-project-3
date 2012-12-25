//
//  Document.m
//  iDNA
//
//  Created by Igor Pavlov on 25.12.12.
//  Copyright (c) 2012 Igor Pavlov. All rights reserved.
//

#import "Document.h"
#import "Cell.h"
#import "Cell+mutator.h"
#import "Cell+hybrid.h"

@implementation Document


+ (void) initialize
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

    [defaultValues setObject:[NSNumber numberWithInteger:10000] forKey:@"MaxPopulationSize"];
    [defaultValues setObject:[NSNumber numberWithInteger:1]     forKey:@"MinPopulationSize"];

    [defaultValues setObject:[NSNumber numberWithInteger:256]   forKey:@"MaxDnaLength"];
    [defaultValues setObject:[NSNumber numberWithInteger:1]     forKey:@"MinDnaLength"];

    [defaultValues setObject:[NSNumber numberWithInteger:100]   forKey:@"MaxMutationRate"];
    [defaultValues setObject:[NSNumber numberWithInteger:0]     forKey:@"MinMutationRate"];

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}


- (id)init
{
    self = [super init];
    if (self)
    {
        self->goalDna         = nil;
        self->population      = nil;
        self.goalDnaString    = @"";
        [self setValue:[NSNumber numberWithInteger:10]  forKey:@"populationSize"];
        [self setValue:[NSNumber numberWithInteger:42]  forKey:@"dnaLength"];
        [self setValue:[NSNumber numberWithInteger:1]   forKey:@"mutationRate"];
        self.generationRound  = 0;
        self.bestDnaMatch     = 0;
        self.evolutionStarted = NO;
        self.breakEvolution   = NO;
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
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}


+ (BOOL) autosavesInPlace
{
    return YES;
}


- (NSData*) dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSMutableData   *data     = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

    [archiver encodeObject:goalDna           forKey:@"goalDna"];
    [archiver encodeObject:population        forKey:@"population"];

    [archiver encodeInteger:dnaLength        forKey:@"dnaLength"];
    [archiver encodeInteger:populationSize   forKey:@"populationSize"];
    [archiver encodeInteger:mutationRate     forKey:@"mutationRate"];

    [archiver encodeInteger:_generationRound forKey:@"generationRound"];
    [archiver encodeDouble:_bestDnaMatch     forKey:@"bestDnaMatch"];

    [archiver finishEncoding];

    return data;
}


- (BOOL) readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    @try
    {
        [self willChangeValueForKey:@"goalDna"];
        [self willChangeValueForKey:@"population"];

        [self willChangeValueForKey:@"dnaLength"];
        [self willChangeValueForKey:@"populationSize"];
        [self willChangeValueForKey:@"mutationRate"];

        [self willChangeValueForKey:@"generationRound"];
        [self willChangeValueForKey:@"bestDnaMatch"];

        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

        self->goalDna        = [unarchiver decodeObjectForKey:@"goalDna"];
        self->population     = [unarchiver decodeObjectForKey:@"population"];
        
        self->dnaLength      = [unarchiver decodeIntegerForKey:@"dnaLength"];
        self->populationSize = [unarchiver decodeIntegerForKey:@"populationSize"];
        self->mutationRate   = [unarchiver decodeIntegerForKey:@"mutationRate"];

        self->_generationRound = [unarchiver decodeIntegerForKey:@"generationRound"];
        self->_bestDnaMatch    = [unarchiver decodeDoubleForKey:@"bestDnaMatch"];

        [unarchiver finishDecoding];

        [self didChangeValueForKey:@"goalDna"];
        [self didChangeValueForKey:@"population"];

        [self didChangeValueForKey:@"dnaLength"];
        [self didChangeValueForKey:@"populationSize"];
        [self didChangeValueForKey:@"mutationRate"];

        [self didChangeValueForKey:@"generationRound"];
        [self didChangeValueForKey:@"bestDnaMatch"];

        if (goalDna)
            self.goalDnaString = [goalDna description];
    }
    @catch (NSException *exception)
    {
        if (outError)
        {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The file is invalid" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
        }
        return NO;
    }

    return YES;
}


- (void) setDnaLength:(NSInteger)dl
{
    dnaLength    = dl;
    self.goalDna = [[Cell alloc] initWithSize:[self dnaLength]];
}


- (NSInteger) dnaLength
{
    return dnaLength;
}


- (void) setPopulationSize:(NSInteger)ps
{
    populationSize = ps;
}


- (NSInteger) populationSize
{
    return populationSize;
}


- (void) setMutationRate:(NSInteger)mr
{
    mutationRate = mr;
}


- (NSInteger) mutattionRate
{
    return mutationRate;
}


- (void) setGoalDna:(Cell*)cell
{
    goalDna = cell;
    if (goalDna)
        self.goalDnaString = [goalDna description];
}


- (IBAction) onStartEvolution:(id)sender
{
    population = [NSMutableArray arrayWithCapacity:populationSize];
    for (NSInteger i = 0; i != populationSize; ++i)
    {
        Cell *newDna = [[Cell alloc] initWithSize:dnaLength];
        [population addObject:newDna];
    }

    self.evolutionStarted = YES;
    self.breakEvolution   = NO;

    [self performSelectorInBackground:@selector(evolutionMainMethod:) withObject:nil];
}


- (IBAction) onPause:(id)sender
{
    self.breakEvolution = YES;
}


- (IBAction) onLoadGoalDna:(id)sender
{
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];

    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setCanCreateDirectories:NO];
    [openDlg setPrompt:@"Select DNA goal file"];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setAllowedFileTypes:@[@"txt", @"dna"]];

    if (NSOKButton != [openDlg runModal])
        return;

    NSString *dnaStr = [NSString stringWithContentsOfURL:[openDlg URL] encoding:NSASCIIStringEncoding error:nil];
    if (!dnaStr)
        return;

    const NSInteger maxDnaLength = [[NSUserDefaults standardUserDefaults] integerForKey:@"MaxDnaLength"];
    if ([dnaStr length] > maxDnaLength)
        return;

    Cell *newGoalDna = [[Cell alloc] initWithDnaString:dnaStr];
    if (!newGoalDna)
        return;

    self.dnaLength = [[newGoalDna description] length];
    self.goalDna   = newGoalDna;
}


- (void) evolutionMainMethod:(id)arg
{
    self.generationRound = 0;

    while (!self.breakEvolution)
    {
        [population sortUsingComparator:^ NSComparisonResult(Cell *lhs, Cell *rhs)
                                        {
                                            const NSInteger ld = [lhs hammingDistance:goalDna];
                                            const NSInteger rd = [rhs hammingDistance:goalDna];

                                            if (ld < rd)
                                                return NSOrderedAscending;

                                            if (ld > rd)
                                                return NSOrderedDescending;

                                            return NSOrderedSame;
                                        }
        ];

        const NSInteger bestMatch = [[population objectAtIndex:0] hammingDistance:self->goalDna];
        self.bestDnaMatch = 1.0 - (double)bestMatch/dnaLength;
        if (0 == bestMatch)
            break;

        const NSUInteger hybridizationStartIndex = populationSize/2;
        for (NSUInteger i = hybridizationStartIndex; i != populationSize; ++i)
        {
            const NSUInteger i1 = hybridizationStartIndex > 0 ? arc4random_uniform((u_int32_t)hybridizationStartIndex) : 0;
            const NSUInteger i2 = hybridizationStartIndex > 1 ? arc4random_uniform((u_int32_t)hybridizationStartIndex) : 0;
            [population replaceObjectAtIndex:i withObject:[Cell makeHybridWith:[population objectAtIndex:i1] andWith:[population objectAtIndex:i2]]];
        }

        for (Cell *c in population)
            [c mutate:mutationRate];

        ++self.generationRound;
    }

    self.evolutionStarted = NO;
}


@end
