//
//  AppDelegate.m
//  TestUndoManager
//
//  Created by Sergey on 24.12.12.
//  Copyright (c) 2012 Sergey. All rights reserved.
//

#import "AppDelegate.h"

static void *RMDocumentKVOContext;
@implementation AppDelegate {
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self addObserver:self forKeyPath:@"testNum" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
}

-(id)init {
    self = [super init];
    if (self) {
           undo = [[NSUndoManager alloc]init];
    }
    return self;
}

-(void)setTestNum:(NSInteger) x {
    testNum = x;
}

-(NSInteger)testNum {
    return testNum;
}

- (NSUndoManager*) windowWillReturnUndoManager: (NSWindow*) window
{

    NSLog(@"windowWillReturnUndoManager");
    return undo;
}

-(void)changeKeyPath:(NSString*)keyPath
             ofObject:(id)obj
              toValue:(id)newValue {
    [obj setValue:newValue forKeyPath:keyPath];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context   {
    if (context != &RMDocumentKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
    NSLog(@"oldValue = %@",oldValue);
     NSLog(@"before replacing: canUndo:%d", [undo canUndo]);
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
    [undo setActionName:@"Edit"];
    NSLog(@"after replacing: canUndo:%d", [undo canUndo]); //prints

    
}

    

@end
