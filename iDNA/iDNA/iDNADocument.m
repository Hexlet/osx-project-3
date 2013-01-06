//
//  iDNADocument.m
//  iDNA
//
//  Created by Администратор on 1/5/13.
//  Copyright (c) 2013 Администратор. All rights reserved.
//

#import "iDNADocument.h"
#import "ResultController.h"

@implementation iDNADocument {
	BOOL paused;
	ResultController *rc;
	NSThread *evolutionThread;
}

@synthesize goalDNAText = _goalDNAText;

- (id)init
{
    self = [super init];
    if (self) {
		populationSize = 1000;
		DNALength = 30;
		mutationRate = 5;
		
		goalDNA = [[Cell alloc] initWithLength: DNALength];
		[_goalDNAText setStringValue: [goalDNA description]];
								
		[self addObserver:self forKeyPath:@"DNALength" options:NSKeyValueObservingOptionOld context:@"DNALengthChanged"];
    }
    return self;
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"DNALength"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == @"DNALengthChanged") { // изменился размер целевой ДНК - перегенерируем новую
		[goalDNA changeLength: DNALength];
		[_goalDNAText setStringValue: [goalDNA description]];
	}
}

- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"iDNADocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.	
		
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	return [[_goalDNAText stringValue] dataUsingEncoding: NSUTF8StringEncoding];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{	
//	NSString *s = nil;
//    @try {
//        s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    }
//    @catch (NSException *e) {
//        if (outError) {
//            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The file is invalid" forKey:NSLocalizedFailureReasonErrorKey];
//            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
//            return NO;
//        }
//    }
//	if ([s length] != DNALength) {
//		NSAlert *alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Length of loaded GoalDNA must be %i elements", DNALength];
//		[alert beginSheetModalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:nil contextInfo:NULL];
//		return NO;
//	}
//	goalDNA = [[Cell alloc] initWithString: s];
//    [_goalDNAText setStringValue:s];
    return YES;
}

- (void) evolution {
	int bestMatch = 0, overallBestMatch = 0, bestDistance = 0, generation = 0;
	BOOL found = NO;
	
	while (!found) {
		if (!paused) {
			generation++;
			
			[p sortToGoalDNA];
			
			bestDistance = [[p.population objectAtIndex: 0] hammingDistance:goalDNA];
			bestMatch = 100 - 100 * bestDistance / DNALength;
			
			if (bestMatch > overallBestMatch) {
				overallBestMatch = bestMatch;
				[_overallBestMatch setStringValue: [NSString stringWithFormat:@"Overall best individual match - %i%%", overallBestMatch]];
			}
			
			[_generation setStringValue: [NSString stringWithFormat:@"Generation - %i", generation]];
			[_bestMatch setStringValue: [NSString stringWithFormat:@"Current generation best individual match - %i%%", bestMatch]];
						
			[p crossPopulationTopPercent:50];
			[p mutate:mutationRate];
			
			if (bestDistance == 0) found = YES;
		}
	}
	// вышли из цикла - приводим контролы в прежнее положенее
	[_populationSizeText setEnabled:YES];
	[_populationSizeSlider setEnabled:YES];
	[_DNALengthText setEnabled:YES];
	[_DNALengthSlider setEnabled:YES];
	[_mutationRateText setEnabled:YES];
	[_mutationRateSlider setEnabled:YES];
	
	[_startEvolution setEnabled:YES];
	[_loadGoalDNA setEnabled:YES];
	[_pause setEnabled:NO];
	
	// показываем панель с ркзультатом
	rc = [[ResultController alloc] initWithGeneration:generation];
	[rc showWindow: self];
}

- (IBAction)startEvolutionClicked:(NSButton *)sender {
	p = [[Population alloc] initWithSize:populationSize andDNALength:DNALength andGoalDNA:goalDNA];
	
	[_populationSizeText setEnabled:NO];
	[_populationSizeSlider setEnabled:NO];
	[_DNALengthText setEnabled:NO];
	[_DNALengthSlider setEnabled:NO];
	[_mutationRateText setEnabled:NO];
	[_mutationRateSlider setEnabled:NO];
	
	[_startEvolution setEnabled:NO];
	[_loadGoalDNA setEnabled:NO];
	[_pause setEnabled:YES];
	
	paused = NO;
		
	evolutionThread = [[NSThread alloc] initWithTarget:self selector:@selector(evolution) object:nil];
	[evolutionThread start];
	//[self performSelectorInBackground:@selector(evolution) withObject:nil];
}

- (IBAction)pauseClicked:(NSButton *)sender {
	paused = !paused;
	if (paused) [_pause setTitle:@"Continue"];
	else [_pause setTitle:@"Pause"];
}

- (IBAction)loadGoalDNAClicked:(NSButton *)sender {
	NSOpenPanel *goalDNAOpenPanel = [NSOpenPanel openPanel];
    NSInteger result = [goalDNAOpenPanel runModal];
    if (result == NSOKButton) {
        NSString *s = [NSString stringWithContentsOfURL:[goalDNAOpenPanel URL] encoding:NSUTF8StringEncoding error:nil];
        if ([s length] != DNALength) {
			NSAlert *alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Length of goal DNA must be equal %i elements", DNALength];
            [alert beginSheetModalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:nil contextInfo:NULL];
        }
        else {
			goalDNA = [[Cell alloc] initWithString: s];
			[_goalDNAText setStringValue:s];
        }
	}
}
@end
