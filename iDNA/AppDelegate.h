//
//  AppDelegate.h
//  iDNA
//
//  Created by Kirill Gorshkov on 25.12.12.
//  Copyright (c) 2012 Kirill Gorshkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Cell.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSInteger populationSize;
    NSInteger dnaLength;
    NSInteger mutationRate;
    NSInteger generationCount;
    NSString *goalDNA;
    Cell *myDNA;
    NSMutableArray *populationArray;
    BOOL evolutionIsRunning;
    double hamDistance;
}

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak) IBOutlet NSTextField *popSizeTextField;
@property (weak) IBOutlet NSTextField *dnaLengthTextField;
@property (weak) IBOutlet NSTextField *mutRateTextField;
@property (weak) IBOutlet NSSlider *popSizeSlider;
@property (weak) IBOutlet NSSlider *dnaLengthSlider;
@property (weak) IBOutlet NSButton *startEvoButton;
@property (weak) IBOutlet NSButton *pauseEvoButton;
@property (weak) IBOutlet NSButton *updateButton;
@property (weak) IBOutlet NSButton *loadButton;

@property (unsafe_unretained) IBOutlet NSTextView *goalDNATextField;

- (IBAction)startEvo:(id)sender;
- (IBAction)updateGoal:(id)sender;
- (IBAction)pauseEvo:(id)sender;
- (IBAction)loadGoal:(id)sender;


- (IBAction)saveAction:(id)sender;

@end
