//
//  Document.m
//  iDNA
//
//  Created by vladimir on 14.01.13.
//  Copyright (c) 2013 Владимир Ковалев. All rights reserved.
//

#import "Document.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        [self setValue:[NSNumber numberWithInt:42] forKey:@"length"];
        [self setValue:[NSNumber numberWithInt:3100] forKey:@"population_size"];
        DNA = [[Cell alloc] initWidthCapacity:length];
        [self addObserver:self forKeyPath:@"length" options:0 context:@"did"];
    }
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    DNA = [[Cell alloc] initWidthCapacity:length];
    [_goalDnaLabel setStringValue:[[DNA returnDNA] componentsJoinedByString:@""]];
}

-(void) createPopulation:(NSInteger)x {
    Population = [[NSMutableArray alloc] initWithCapacity:x];
    for(int i = 0; i <= x; i++) {
        [Population addObject:[[Cell alloc] initWidthCapacity:length]];
    }
    //NSLog(@"%@",Population);
    //NSLog(@"%@",DNA);
}

- (IBAction)startEvolution:(id)sender {
    [self createPopulation:population_size];
    int hd = 0;
    int tmp_hd;
    for (int i = 0; i <= population_size; i++) {
        [_generation setStringValue:[NSString stringWithFormat:@"Generation: %i", i]];
        if ((tmp_hd = [[Population objectAtIndex:i] hammingDistance:DNA]) <= hd) {
            hd = tmp_hd;
            [_hammingDistance setStringValue:[NSString stringWithFormat:@"Hamming distance: %i", hd]];
        } else {
            hd = tmp_hd;
        }
        if (hd == 0) {
            [_generation setStringValue:[NSString stringWithFormat:@"Generation: %i Whola!", i]];
            break;
        }
    }
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
    [_goalDnaLabel setStringValue:[[DNA returnDNA] componentsJoinedByString:@""]];
    [_populationSize setStringValue:[NSString stringWithFormat:@"%li",population_size]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

- (void) dealloc {
    [self removeObserver:self forKeyPath:@"length"];
}

@end
