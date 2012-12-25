#import <Cocoa/Cocoa.h>

@class Evolution;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    Evolution *evolution;
}

@property (assign) IBOutlet NSWindow *window;
@property Evolution *evolution;
@property (readonly) BOOL canChangeParams;
@property (readonly) NSString *startStopButtonTitle;
@property (readonly) NSString *pauseResumeButtonTitle;
@property (readonly) BOOL pauseResumeButtonIsEnabled;

-(IBAction)startStopEvolution:(id)sender;
-(IBAction)pauseResumeEvolution:(id)sender;


@end
