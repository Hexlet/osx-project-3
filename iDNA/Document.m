//
//  Document.m
//  iDNA
//
//  Created by D_Unknown on 12/25/12.
//  Copyright (c) 2012 D_unknown. All rights reserved.
//

#import "Document.h"

@implementation Document

- (id) init
{
    self = [super init];
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
    populationSize=5000;
    [self setPopSize];
        
    DNALength=50;
    [self setDNALen];
    
    mutationRate=50;
    [self setMutRate];
    
    generation=0;
    [self setGen]; 
    
    bestMatch=0;
    [self setBestMatch];
    
    [self createGoal];
    
    stopped=NO;
    [stopBut setEnabled:NO];

}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    /*
     Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    */
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    /*
    Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    */
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}



- (IBAction)startEvolution:(id)sender {
    //set default generation, best match and best DNA
    generation=0;
    [self setGen]; 
    bestMatch=0;
    [self setBestMatch];
    [bestDNAField setStringValue:@""];
    
    //disable/enable textfield, sliders and buttons
    [popSizeField setEnabled:NO];
    [popSizeSlider setEnabled:NO];
    [DNALenField setEnabled:NO];
    [DNALenSlider setEnabled:NO];
    [startBut setEnabled:NO];
    [stopBut setEnabled:YES];
    [loadBut setEnabled:NO];
    
    //create population
    population = [[NSMutableArray alloc] init];
    for(int i=0; i<populationSize; i++)
        [population addObject:[[Cell alloc] initWithLength:DNALength]];
    
    //start evolutuion thread
    NSThread *evoThread = [[NSThread alloc] initWithTarget:self selector:@selector(evolution) object:nil];
    [evoThread start];
}    

-(void) evolution {    
    while(true) {
        if(stopped) break;
        
        //sort by hamming distance to goal DNA
        [population sortUsingComparator:^(Cell *obj1, Cell *obj2) {
            if ([obj1 hammingDistance:goalDNA]>[obj2 hammingDistance:goalDNA])
                return (NSComparisonResult)NSOrderedDescending;
            if ([obj1 hammingDistance:goalDNA]<[obj2 hammingDistance:goalDNA])
                return (NSComparisonResult)NSOrderedAscending;
            return NSOrderedSame;
        }];
        
        //find best match %, show best DNA, stop evolution if 100%
        bestMatch=100-([[population objectAtIndex:0] hammingDistance:goalDNA]*100/DNALength);
        [self setBestMatch];
        [bestDNAField setStringValue:[[population objectAtIndex:0] getDNAString]];
        if(bestMatch==100) break;
        
        //increment generation number
        generation++;
        [self setGen];
     
        //crossbreed
        int parent1, parent2;
        for(int i=(populationSize/2); i<populationSize; i++) {
            parent1=arc4random()%(populationSize/2);
            do {
                parent2=arc4random()%(populationSize/2);
            }
            while(parent2==parent1);
        [population replaceObjectAtIndex:i withObject:[[population objectAtIndex:parent1] crossbreedWith:[population objectAtIndex:parent2]]];
        }
                
        //mutate population
        for(int i=0; i<populationSize; i++)
            [[population objectAtIndex:i] mutate:mutationRate];
        
    }
    
    //enable/disable textfield, sliders and buttons after evo ends
    [popSizeField setEnabled:YES];
    [popSizeSlider setEnabled:YES];
    [DNALenField setEnabled:YES];
    [DNALenSlider setEnabled:YES];
    [startBut setEnabled:YES];
    [stopBut setEnabled:NO];
    [loadBut setEnabled:YES];
    
    paused=NO;
    stopped=NO;
}

- (IBAction)populationSizeChange:(id)sender {
    populationSize = [sender intValue];
    [self setPopSize];
}

- (IBAction)DNALengthChange:(id)sender {
    DNALength = [sender intValue];
    [self setDNALen];    
    
    [self createGoal];
    
    //set default generation, best match and best DNA
    generation=0;
    [self setGen]; 
    
    bestMatch=0;
    [self setBestMatch];
    
    [bestDNAField setStringValue:@""];
}

- (IBAction)mutationRateChange:(id)sender {
    mutationRate=[sender intValue];
    [self setMutRate];
}

- (IBAction)stopEvol:(id)sender {
    stopped=YES;
    [stopBut setEnabled:NO];
}

- (IBAction)loadGoal:(id)sender {
    NSOpenPanel *goalLoadPanel = [NSOpenPanel openPanel];
    if([goalLoadPanel runModal] == NSOKButton) {
        NSString *file = [goalLoadPanel filename];
        NSString *string = [NSString stringWithContentsOfFile:file
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
        [goalDNA DNAFromString:string withMaxLen:[DNALenSlider maxValue]];
        [goalDNAField setStringValue:[goalDNA getDNAString]];
                
        //if string is longer than max, alert about string cutting
        if([string length]>[DNALenSlider maxValue]) { 
            NSAlert *sizeAlert = [NSAlert alertWithMessageText:@"Warning!" 
                                          defaultButton:@"OK"
                                          alternateButton:nil
                                          otherButton:nil
                                          informativeTextWithFormat:@"Loaded goal DNA is longer than maximum length of %.0f characters. Loaded goal DNA was cut to %.0f characters.",[DNALenSlider maxValue],[DNALenSlider maxValue]]; 
            [sizeAlert beginSheetModalForWindow:[self windowForSheet]
                       modalDelegate:self
                       didEndSelector:nil
                       contextInfo:nil];
            DNALength = [DNALenSlider maxValue];    //set DNA max length
        }
        else {
            DNALength = [string length];            //else if string length is OK, set DNA length as string length
        }
        [self setDNALen];                           //set textfield and slider values
    }
}

-(void) setPopSize {
    [popSizeField setIntValue:populationSize];
    [popSizeSlider setIntValue:populationSize];
}

-(void) setDNALen {
    [DNALenField setIntValue:DNALength];
    [DNALenSlider setIntValue:DNALength];
}

-(void) setMutRate {
    [mutRateField setIntValue:mutationRate];
    [mutRateSlider setIntValue:mutationRate];
}

-(void) setGen {
    [genLabel setStringValue:[NSString stringWithFormat:@"Generation: %i",generation]];
}

-(void) setBestMatch {
    [bestMatchLabel setStringValue:[NSString stringWithFormat:@"Best individual match - %i%%",bestMatch]];
    [bestMatchProg setDoubleValue:bestMatch];
}

-(void) createGoal {
    goalDNA=[[Cell alloc] initWithLength:DNALength];
    [goalDNAField setStringValue:[goalDNA getDNAString]];
}

@end
