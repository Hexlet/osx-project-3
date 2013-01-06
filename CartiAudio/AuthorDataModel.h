//
//  XMLStringFile.h
//  XMLParser
//
//  Created by Ravi Dixit on 20/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AuthorDataModel : NSObject {

	NSString *smallLogoLink,*authorName,*authorSurname;
    NSString *birthDate,*endDate;
	
	NSString *autorID;
}
@property (nonatomic,strong) NSString *smallLogoLink,*authorName,*authorSurname;
@property (nonatomic,strong) NSString *birthDate,*endDate;
@property (nonatomic,strong) NSString *autorID;

-(void) setData:(AuthorDataModel *) loadedData;
@end
