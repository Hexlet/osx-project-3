/**
* Created by undelalune on 27.11.12.
* version 0.1
**/


#import <Foundation/Foundation.h>
#import "Word.h"

@interface StorageHelper : NSObject

+ (BOOL)initStorage;

+ (BOOL)saveData;

+ (NSMutableArray *)loadData;

+ (void)updateWord:(Word *)word atPos:(int)pos;

+ (void)deleteWordAtPos:(int)pos;

@end