//
//  Document.m
//  MyCookbook
//
//  Created by Екатерина Полищук on 06.01.13.
//  Copyright (c) 2013 Екатерина Полищук. All rights reserved.
//

#import "Document.h"
static void *RMDocumentKVOContext;

@implementation Document

-(void)startObservingRecipe:(Recipe *)recipe {
    [recipe addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    [recipe addObserver:self forKeyPath:@"description" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    [recipe addObserver:self forKeyPath:@"manual" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
}

-(void)stopObservingRecipe:(Recipe *)recipe {
    [recipe removeObserver:self forKeyPath:@"title"];
    [recipe removeObserver:self forKeyPath:@"description"];
    [recipe removeObserver:self forKeyPath:@"manual"];
}


- (id)init
{
    self = [super init];
    if (self) {
        recipes = [[NSMutableArray alloc] init];
        allCategories = [[NSMutableSet alloc] initWithObjects:@"All recipes", nil];
    }
    return self;
}


-(void)setRecipes:(NSMutableArray *)r {
    if (recipes != r) {
        for (Recipe *recipe in recipes) {
            [self stopObservingRecipe:recipe];
        }
        recipes = r;
        for (Recipe *recipe in recipes) {
            [self startObservingRecipe:recipe];
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
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    [[table window] endEditingFor:nil];
    return [NSKeyedArchiver archivedDataWithRootObject:recipes];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSMutableArray *newArray = nil;
    @try {
        newArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e) {
        if (outError) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The file is invalid" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
            return NO;
        }
    }
    [self setRecipes:newArray];
    return YES;
}

-(void)insertObject:(Recipe *)r inRecipesAtIndex:(NSInteger)index {
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self]removeObjectFromRecipesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Add recipe"];
    }
    [self startObservingRecipe:r];
    [recipes insertObject:r atIndex:index];
}

-(void)removeObjectFromRecipesAtIndex:(NSInteger)index {
    NSUndoManager *undo = [self undoManager];
    Recipe *r = [recipes objectAtIndex:index];
    [[undo prepareWithInvocationTarget:self]insertObject:r inRecipesAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Remove recipe"];
    }
    [self stopObservingRecipe:r];
    [recipes removeObjectAtIndex:index];
}


-(void)changeKeyPath:(NSString*)keyPath
            ofObject:(id)obj
             toValue:(id)newValue {
    [obj setValue:newValue forKeyPath:keyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    NSUndoManager *undo = [self undoManager];
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    
    [undo setActionName:@"Edit"];
}


@end

