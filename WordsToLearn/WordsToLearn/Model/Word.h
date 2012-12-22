/**
* Created by user on 25.11.12.
* version 0.1
**/


#import <Foundation/Foundation.h>


@interface Word : NSObject <NSCoding>

@property(nonatomic, strong) NSString *word;
@property(nonatomic, strong) NSString *translation;

@end