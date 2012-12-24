//
//  LoadSaveController.h
//  iDNA
//
//  Created by Admin on 24.12.12.
//  Copyright (c) 2012 Kabest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadSaveController : NSObject {
    NSURL *url;
}

-(NSURL*)getURL;
-(IBAction)doSave:(id)aId;
-(IBAction)doOpen:(id)aId;

@end
