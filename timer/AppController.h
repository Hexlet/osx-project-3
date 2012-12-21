//
//  AppController.h
//  timer
//
//  Created by Максим on 19.12.12.
//  Copyright (c) 2012 CarelessApps. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Preferences;

@interface AppController : NSObject{
    Preferences *pref;
}

-(IBAction)showPref:(id)sender;


@end
