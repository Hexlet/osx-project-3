//
//  AppDelegate.m
//  passwordGenerator
//
//  Created by padawan on 25.12.12.
//  Copyright (c) 2012 padawan. All rights reserved.
//

#import "AppDelegate.h"
const void *RMDocumentKVOContext;
@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}


-(id) init {
    if(self = [super init]) {
        [self setValue:[NSNumber numberWithInt:8 ] forKey:@"lengthPassword"];
        upperCaseCheck = 1;
        numberCaseCheck = 1;
        lowerCase = [NSMutableArray arrayWithObjects:
                     @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"g", @"k", @"l", @"m",
                     @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z",
                     nil];
        upperCaseSymbol = [NSMutableArray arrayWithObjects:
                     @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"G", @"K", @"L", @"M",
                     @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",
                     nil];
        numberCase = [NSMutableArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",nil];

        [self addObserver:self forKeyPath:@"lengthPassword" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
        
        [self addObserver:self forKeyPath:@"upperCaseCheck" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
        [self addObserver:self forKeyPath:@"numberCaseCheck" options:NSKeyValueObservingOptionOld context:&RMDocumentKVOContext];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(keyPath == @"lengthPassword") {
        [_lengthField setStringValue:[NSString stringWithFormat:@"%@", _lengthPassword]];
    }
    [_passwordField setStringValue:[self generate]];
}

-(id) generate {
    id symbol;
    NSMutableArray *currentCase = [[NSMutableArray alloc] init];
    NSString *p = [NSString stringWithFormat:@""];
    NSMutableArray *cases = [[NSMutableArray alloc] init];
    
    [cases addObject:lowerCase];
    
    if (upperCaseCheck) {
        [cases addObject:upperCaseSymbol];
    }
    if (numberCaseCheck) {
        [cases addObject:numberCase];
    }
    for (int i = 0; i<[_lengthPassword intValue]; i++) {
        currentCase = [cases objectAtIndex:arc4random()%[cases count]];
        symbol = [currentCase objectAtIndex: arc4random()%currentCase.count];
        p = [p stringByAppendingString:symbol];
    }
    return p;
}

- (IBAction)clickOnUpperCase:(id)sender {
    [self willChangeValueForKey:@"upperCaseCheck"];
    upperCaseCheck = [sender intValue];
    [self didChangeValueForKey:@"upperCaseCheck"];
}

- (IBAction)clickeOnNumberCase:(id)sender {
    [self willChangeValueForKey:@"numberCaseCheck"];
    numberCaseCheck = [sender intValue];
    [self didChangeValueForKey:@"numberCaseCheck"];
}

- (IBAction)clickGenerate:(id)sender {
    [_passwordField setStringValue:[self generate]];
}
@end
