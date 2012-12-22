/**
* Created by user on 25.11.12.
* version 0.1
* This class is used as a model
* for our words. We save this class
* in plist file.
**/


#import "Word.h"


@implementation Word

@synthesize word, translation;

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:word forKey:@"wordStr"];
    [coder encodeObject:translation forKey:@"translationStr"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    word = [coder decodeObjectForKey:@"wordStr"];
    translation = [coder decodeObjectForKey:@"translationStr"];
    return self;
}
@end