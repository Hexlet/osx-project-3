//
//  AppDelegate.m
//  iDNA
//
//  Created by Kirill Gorshkov on 25.12.12.
//  Copyright (c) 2012 Kirill Gorshkov. All rights reserved.
//

#import "AppDelegate.h"




@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

-(id)init {
    if (self = [super init]) {
        [self setValue:[NSNumber numberWithInteger:2] forKey:@"populationSize"];
        [self setValue:[NSNumber numberWithInteger:10] forKey:@"dnaLength"];
        [self setValue:[NSNumber numberWithInteger:10] forKey:@"mutationRate"];
        [self setValue:[NSNumber numberWithInteger:0] forKey:@"generationCount"];
        [self setValue:[NSNumber numberWithDouble:0.0] forKey:@"hamDistance"];
        
        evolutionIsRunning = NO;
        
        myDNA = [[Cell alloc] init];
        [myDNA initialize:dnaLength];
        NSLog(@"%@", [myDNA getGoalDNA]);
    }
    return self;
}

-(void)setPopulationSize:(NSInteger)x {
    [_popSizeTextField setStringValue:[NSString stringWithFormat:@"%ld", x]];
    populationSize = x;
}

-(NSInteger)populationSize {
    return populationSize;
}

-(void)setDnaLength:(NSInteger)x {
    [_dnaLengthTextField setStringValue:[NSString stringWithFormat:@"%ld", x]];
    dnaLength = x;
}

-(NSInteger)dnaLength {
    return dnaLength;
}

-(void)setMutationRate:(NSInteger)x {
    [_mutRateTextField setStringValue:[NSString stringWithFormat:@"%ld", x]];
    mutationRate = x;
}

-(NSInteger)mutationRate {
    return mutationRate;
}

-(void)setHamDistance:(double)x {
    hamDistance = x;
}

-(double)hamDistance {
    return hamDistance;
}

-(void)setGenerationCount:(NSInteger)x {
    generationCount = x;
}

-(NSInteger)generationCount {
    return generationCount;
}

-(IBAction)startEvo:(id)sender {
    if ([myDNA length] != dnaLength) {
        NSLog(@"INCORRECT GOAL DNA LENGTH");
    }
    else {
        [_popSizeSlider setEnabled:NO];
        [_dnaLengthSlider setEnabled:NO];
        [_startEvoButton setEnabled:NO];
        [_pauseEvoButton setEnabled:YES];
        [_updateButton setEnabled:NO];
        [_loadButton setEnabled:NO];
    
        populationArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < populationSize; i++) {
            Cell *newDNA = [[Cell alloc] init];
            [newDNA initialize:dnaLength];
            [populationArray addObject:newDNA];
        }
        evolutionIsRunning = YES;
        [self performSelectorInBackground:@selector(startEvolution) withObject:nil];
    }
}

-(void)startEvolution {
    while (YES){
        if (evolutionIsRunning) {
            int currentHammingDistance = 0;
            NSLog(@"EVO");
            BOOL flag = YES;
            while (flag) {
                flag = NO;
                for (int i = 0; i < populationSize - 1; i++) {
                    if ([[populationArray objectAtIndex:i] hammingDistance:myDNA] >
                        [[populationArray objectAtIndex:i + 1] hammingDistance:myDNA]) {
                        Cell *tempDNA = [populationArray objectAtIndex:i];
                        [populationArray replaceObjectAtIndex:i withObject:[populationArray objectAtIndex:i + 1]];
                        [populationArray replaceObjectAtIndex:i + 1 withObject:tempDNA];
                        flag = YES;
                    }
                }
            }
            
            currentHammingDistance = [[populationArray objectAtIndex:0] hammingDistance:myDNA];
            [[populationArray objectAtIndex:0] print];
            [self setHamDistance:(1 - ((double)currentHammingDistance / dnaLength))];
            if (currentHammingDistance == 0) {
                // STOP EVO!
                evolutionIsRunning = NO;
            }
            // PERFORM REPRODUCTION
            int top50Count = populationSize * 0.5;
            if (top50Count > 1) {
                for (int i = top50Count; i < populationSize; i++) {
                    srandom((unsigned)time(NULL));
                    int reproRand1 = (int)(random() % top50Count);
                    int reproRand2 = (int)(random() % top50Count);
                    while (reproRand1 == reproRand2) {
                        reproRand2 = (int)(random() % top50Count);
                    }
                    Cell *reproductionDNA = [populationArray objectAtIndex:reproRand1];
                    //[reproductionDNA print];
                    [reproductionDNA reproduct:[populationArray objectAtIndex:reproRand2]];
                    //[reproductionDNA print];
                    [populationArray replaceObjectAtIndex:i withObject:reproductionDNA];
                }
            }
            // END REPRODUCTION
            int minHammingDistance = [[populationArray objectAtIndex:0] hammingDistance:myDNA];
            for (int i = 0; i < populationSize ; i++) {
                currentHammingDistance = [[populationArray objectAtIndex:i] hammingDistance:myDNA];
                if (currentHammingDistance < minHammingDistance )
                    minHammingDistance = currentHammingDistance;
                if (currentHammingDistance == 0) {
                    // STOP EVO!
                    evolutionIsRunning = NO;
                }
            }
            currentHammingDistance = minHammingDistance;
            [self setHamDistance:(1 - ((double)currentHammingDistance / dnaLength))];
            NSLog(@"%f", ((double)currentHammingDistance / dnaLength));
            for (int i = 0; i < populationSize; i++) {
                Cell *mutableDNA = [populationArray objectAtIndex:i];
                //[mutableDNA print];
                [mutableDNA mutate:mutationRate];
                //[mutableDNA print];
                [populationArray replaceObjectAtIndex:i withObject:mutableDNA];
            }
            [self setGenerationCount:generationCount + 1];
        }
    }
}

- (IBAction)updateGoal:(id)sender {
    [myDNA updateGoalDNA:dnaLength];
    [_goalDNATextField setString:[myDNA getGoalDNA]];
}

- (IBAction)pauseEvo:(id)sender {
    if ([myDNA length] != dnaLength) {
        NSLog(@"INCORRECT GOAL DNA LENGTH");
    }
    else {
        evolutionIsRunning = !evolutionIsRunning;
        if (evolutionIsRunning) {
            [_updateButton setEnabled:NO];
            [_loadButton setEnabled:NO];
            [_pauseEvoButton setTitle:@"Pause"];
        }
        else {
            [_updateButton setEnabled:YES];
            [_loadButton setEnabled:YES];
            [_pauseEvoButton setTitle:@"Continue"];
        }
    }
}

- (IBAction)loadGoal:(id)sender {
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_popSizeTextField setStringValue:[NSString stringWithFormat:@"%ld", populationSize]];
    [_dnaLengthTextField setStringValue:[NSString stringWithFormat:@"%ld", dnaLength]];
    [_mutRateTextField setStringValue:[NSString stringWithFormat:@"%ld", mutationRate]];
    [_goalDNATextField setString:[myDNA getGoalDNA]];
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "myCompany.iDNA" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"myCompany.iDNA"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iDNA" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"iDNA.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.

- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
