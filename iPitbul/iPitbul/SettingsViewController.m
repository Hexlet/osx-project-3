//
//  SettingsViewController.m
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 15.12.12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utils.h"
#import "SettingsUtils.h"
#import "Constants.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pitbulPhoneNumberField.text = [SettingsUtils pitbulPhoneNumber];
    _pitbulPasswordField.text = [SettingsUtils pitbulPassword];
    if (![SettingsUtils isSettingsConfigured]) {
        [_cancelButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)save:(id)sender {
    if (![self isValidatePitbulPhoneNumber]) {
        [Utils errorDialogWithTitle:NSLocalizedString(@"error.title", nil) andMessage:NSLocalizedString(@"settings.view.error.message.invalidPitbulPhoneNumber", nil)];
        return;
    }
    if (![self isValidatePitbulPassword]) {
        [Utils errorDialogWithTitle:NSLocalizedString(@"error.title", nil) andMessage:NSLocalizedString(@"settings.view.error.message.invalidPitbulPassword", nil)];
        return;
    }
    
    [SettingsUtils saveSettings:[NSDictionary dictionaryWithObjectsAndKeys:_pitbulPhoneNumberField.text, PITBUL_PHONE_NUMBER, _pitbulPasswordField.text, PITBUL_PASSWORD, nil]];
    
    [self.delegate settingsViewControllerDidFinish:self];
}

- (IBAction)cancel:(id)sender {  
    [self.delegate settingsViewControllerDidFinish:self];
}


- (BOOL)isValidatePitbulPhoneNumber {
    return [_pitbulPhoneNumberField.text length] != 0;
}

- (BOOL)isValidatePitbulPassword {
    return [_pitbulPasswordField.text length] == 4;
}

@end
