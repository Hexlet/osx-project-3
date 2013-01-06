//
//  XMLStringFile.m
//  XMLParser
//
//  Created by Ravi Dixit on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthorDataModel.h"


@implementation AuthorDataModel
@synthesize smallLogoLink,authorName,authorSurname;
@synthesize autorID;
@synthesize birthDate,endDate;

-(void) setData:(AuthorDataModel *) loadedData
{
    self.authorName=[loadedData authorName];
    self.authorSurname=[loadedData authorSurname];
    self.autorID=[loadedData autorID];
    self.smallLogoLink=[loadedData smallLogoLink];
    self.birthDate=[loadedData birthDate];
    self.endDate=[loadedData endDate];
}

@end
