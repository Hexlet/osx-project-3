#import <Foundation/Foundation.h>

@class Cell;

@interface Evolution : NSObject {
    BOOL paused;
    BOOL inProgress;
    NSMutableArray *population;
    NSInteger populationSize;
    NSInteger generation;
    NSInteger mutationRate;
    NSInteger dnaLength;
    Cell *goalCell;
}

@property (assign) NSInteger populationSize;
@property (assign) NSInteger dnaLength;
@property (assign) NSInteger mutationRate;
@property (assign) BOOL paused;
@property (assign) BOOL inProgress;
@property (readonly) NSInteger generation;

-(void)start;
-(void)stop;
-(void)pause;
-(void)resume;

@end
