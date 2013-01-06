#import "AppDelegate.h"
#import "Evolution.h"

@implementation AppDelegate

@synthesize evolution;

-(id)init {
    self = [super init];
    if (self) {
        evolution = [[Evolution alloc] init];
        evolution.populationSize = 100;
        evolution.dnaLength = 20;
        evolution.mutationRate = 10;
        [evolution setDelegate:self];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

-(IBAction)startStopEvolution:(id)sender {
    [self willChangeState];
    if (evolution.inProgress) {
        [evolution stop];
    } else {
        [evolution start];
    }
    [self didChangeState];
}

-(IBAction)pauseResumeEvolution:(id)sender {
    [self willChangeState];
    if (evolution.paused) {
        [evolution resume];
    } else {
        [evolution pause];
    }
    [self didChangeState];
}

-(void)willChangeState {
    [self willChangeValueForKey:@"canChangeParams"];
    [self willChangeValueForKey:@"startStopButtonTitle"];
    [self willChangeValueForKey:@"pauseResumeButtonTitle"];
    [self willChangeValueForKey:@"pauseResumeButtonIsEnabled"];
}

-(void)didChangeState {
    [self didChangeValueForKey:@"canChangeParams"];
    [self didChangeValueForKey:@"startStopButtonTitle"];
    [self didChangeValueForKey:@"pauseResumeButtonTitle"];
    [self didChangeValueForKey:@"pauseResumeButtonIsEnabled"];
}

-(BOOL)canChangeParams {
    return evolution.inProgress == NO;
}

-(NSString *)startStopButtonTitle {
    return evolution.inProgress ? @"Stop evolution" : @"Start Evolution";
}

-(NSString *)pauseResumeButtonTitle {
    return evolution.paused ? @"Resume" : @"Pause";
}

-(BOOL)pauseResumeButtonIsEnabled {
    return evolution.inProgress == YES;
}

-(void)evolutionStateHasChanged:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    [generationLabel setStringValue:[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"generation"]]];
    NSNumber *bestMatch = [userInfo objectForKey:@"bestMatch"];
    [bestMatchLabel setStringValue:[NSString stringWithFormat:@"%@%%", bestMatch]];
    [progressIndicator setDoubleValue: [bestMatch doubleValue]];
}

-(void)evolutionGoalIsReached {
    [self willChangeState];
    [self didChangeState];
}

-(IBAction)loadGoalDNAFromFile:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    if (![openPanel runModal] == NSFileHandlingPanelOKButton) {
        return;
    }
    
    NSString *errorText = nil;
    NSString *dnaString = [NSString stringWithContentsOfURL:[openPanel URL] usedEncoding:nil error:nil];
    NSPredicate *dnaStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[ATGC]+"];
    
    if (dnaString == nil) {
        errorText = @"Cannot read the file";
    } else if (![dnaStringPredicate evaluateWithObject:dnaString]) {
        errorText = @"Text from the file is not DNA";
    } else if ([dnaString length] < 4) {
        errorText = @"DNA is too short";
    } else if ([dnaString length] > 100) {
        errorText = @"DNA is too long";
    }

    if (errorText) {
        [self showAlertWithMessageText:@"Ops" informativeText:errorText];
        return;
    }
    
    [evolution loadGoalDNA:dnaString];
}

-(void)showAlertWithMessageText:(NSString *)text informativeText:(NSString *)informativeText {
    NSAlert *alert = [NSAlert alertWithMessageText:text defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", informativeText];
    [alert runModal];
}

@end
