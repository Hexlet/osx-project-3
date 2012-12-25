//
//  Document.h
//  iDNA
//
//  Created by Anatoly Yashkin on 21.12.12.
//  Copyright (c) 2012 Anatoly Yashkin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument{
    NSInteger populationSize;
    NSInteger dnaLength;
    NSInteger mutationRate;
    NSInteger bestMatch;
    NSInteger generation;
    NSInteger minHammingDistance;
    
    NSString *goalDNA;

    
    //Переменная для активации/декативации элементов формы
    //YES, когда идут расчеты (элементы деактивированны), NO, когда расчеты не идут (элементы активированы)
    BOOL inWork;
    
    //Переменная для отслеживания первого запуска
    //Мы же можем цикл на паузу поставить.
    BOOL firstStart;
    

    NSMutableArray *population;
}


@property (weak) IBOutlet NSTextFieldCell *goalDNATF;
@property (weak) IBOutlet NSTextField *generationLabel;
@property (weak) IBOutlet NSTextField *bestMatchLabel;
@property (weak) IBOutlet NSSlider *populationSizeSlider;
@property (weak) IBOutlet NSTextField *populationSizeTF;
@property (weak) IBOutlet NSSlider *dnaLengthSlider;
@property (weak) IBOutlet NSTextField *dnaLengthTF;
@property (weak) IBOutlet NSSlider *mutationRateSlider;
@property (weak) IBOutlet NSTextField *mutationRateTF;
@property (weak) IBOutlet NSLevelIndicator *progressBar;
@property (weak) IBOutlet NSButton *startEvolutionBtn;
@property (weak) IBOutlet NSButton *stopEvolutionBtn;
@property (weak) IBOutlet NSButton *loadGoalDNABtn;

- (IBAction)startEvalution:(id)sender;
- (IBAction)stopEvolution:(id)sender;
- (IBAction)loadGoalDNA:(id)sender;
-(void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)neValue;


@end
