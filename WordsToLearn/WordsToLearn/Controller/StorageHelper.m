/**
* Created by undelalune on 27.11.12.
* version 0.1
* Static Class is used for data managing.
* Create plist, save, load, update, etc.
**/


#import "StorageHelper.h"

//  plist file name
NSString const *wordsStorage = @"words.plist";
//  current array of words - the most latest version in the entire application
NSMutableArray *words;

@implementation StorageHelper

/**
*  @return BOOL - YES if plist file was successfully created
*  Run this method as soon as application started. It will created plist file
*  if it doesn't exist yet.
*/
+ (BOOL)initStorage
{
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[StorageHelper getStoragePath]];
    if (!exists)
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
        NSError *error;
        exists = [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:[StorageHelper getStoragePath] error:&error];
    }
    return exists;
}

/**
* @return BOOL - YES if data was successfully saved
* Save data before exit from application.
*/
+ (BOOL)saveData
{
    return [NSKeyedArchiver archiveRootObject:words toFile:[StorageHelper getStoragePath]];
}

/**
* @return NSMutableArray - all the existing words excluded from plist
* Loads data if it was not loaded yet, otherwise returns words
*/
+ (NSMutableArray *)loadData
{
    if (words == nil)
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:[StorageHelper getStoragePath]];
        if ([dict count] == 0)
        {
            words = [[NSMutableArray alloc] init];
        } else
        {
            words = [NSKeyedUnarchiver unarchiveObjectWithFile:[StorageHelper getStoragePath]];
        }
    }
    return words;
}

/**
*  @param
*  word - word that needs to be updated ( or added )
*  pos  - current word's position in the array if it exists
*/
+ (void)updateWord:(Word *)word atPos:(int)pos
{
    if ([words count] != 0 && [words count] > pos)
    {
        [words replaceObjectAtIndex:(NSUInteger) pos withObject:word];
    } else
    {
        [words addObject:word];
    }
}

/**
* @param
* pos - position of word that needs to be deleted
*/
+ (void)deleteWordAtPos:(int)pos
{
    [words removeObjectAtIndex:(NSUInteger) pos];
}

/**
* @return NSString - path to the plist
*/
+ (NSString *)getStoragePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:(NSString *) wordsStorage];
}

@end