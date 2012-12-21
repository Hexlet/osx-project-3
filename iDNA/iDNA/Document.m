//
//  Document.m
//  iDNA
//
//  Created by Anatoly Yashkin on 21.12.12.
//  Copyright (c) 2012 Anatoly Yashkin. All rights reserved.
//

#import "Document.h"
#import "Cell.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        //Инициализируем переменные.
        [self setValue:[NSNumber numberWithInt:130] forKey:@"populationSize"];
        [self setValue:[NSNumber numberWithInt:42] forKey:@"dnaLength"];
        [self setValue:[NSNumber numberWithInt:26] forKey:@"mutationRate"];
        [self setValue:[NSNumber numberWithInt:0] forKey:@"bestMatch"];
        
        [self setValue:[Cell getRandomDNA:dnaLength] forKey:@"goalDNA"];
    }
    return self;
}



-(void)setBestMatch:(NSInteger)x{
    [_bestMatchLabel setStringValue:[NSString stringWithFormat:@"Best individual match - %ld%%",x]];
    bestMatch=x;
    
}

-(void)setDnaLength:(NSInteger)x{
    dnaLength=x;
    [self setValue:[Cell getRandomDNA:dnaLength] forKey:@"goalDNA"];
    [_goalDNATF setStringValue:goalDNA];
    
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
    
    [_goalDNATF setStringValue:goalDNA];
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

-(IBAction)startEvalution:(id)sender{

}

@end
