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

@end
