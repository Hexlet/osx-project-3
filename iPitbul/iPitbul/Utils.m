//
//  Utils.m
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 12/22/12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (void)errorDialogWithTitle:(NSString *)title andMessage:(NSString *)message {
    [[[UIAlertView alloc]
      initWithTitle: title
      message: message
      delegate: nil
      cancelButtonTitle:NSLocalizedString(@"button.ok", nil)
      otherButtonTitles:nil] show];
}

@end
