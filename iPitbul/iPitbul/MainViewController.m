//
//  MainViewController.m
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 11/21/12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import "MainViewController.h"
#import "Utils.h"
#import "SettingsUtils.h"
#import "PitbulActionProvider.h"
#import "PitbulAction.h"

#define NUMBER_OF_SECTIONS_IN_TABLE 2
#define DEFAULT_TABLE_HEADER_HEIGHT 44
#define DEFAULT_TABLE_HEADER_WIDTH 300

@interface MainViewController ()

@end

@implementation MainViewController {
    PitbulActionProvider *pitbulActionProvider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pitbulActionProvider = [[PitbulActionProvider alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    if (![SettingsUtils isSettingsConfigured]) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"settingsController"];
//        [vc setModalPresentationStyle:UIModalPresentationFullScreen];
//        
//        [self presentViewController:vc animated:YES completion:nil];
//    }
//}

#pragma mark - Flipside View
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)aboutViewControllerDidFinish:(AboutViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"aboutAlternate"]
        || [[segue identifier] isEqualToString:@"settingsAlternate"]) {
        
        [[segue destinationViewController] setDelegate:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS_IN_TABLE;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return DEFAULT_TABLE_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle;
    
    if(section == 0) {
        sectionTitle = NSLocalizedString(@"main.view.table.header.management.actions", nil);
    } else {
        sectionTitle = NSLocalizedString(@"main.view.table.header.service.actions", nil);
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, DEFAULT_TABLE_HEADER_WIDTH, DEFAULT_TABLE_HEADER_HEIGHT);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DEFAULT_TABLE_HEADER_WIDTH, DEFAULT_TABLE_HEADER_HEIGHT)];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return [[pitbulActionProvider managementActions] count];
    } else {
        return [[pitbulActionProvider serviceActions] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [[[pitbulActionProvider managementActions] objectAtIndex:indexPath.row] title];
    } else {
        cell.textLabel.text = [[[pitbulActionProvider serviceActions] objectAtIndex:indexPath.row] title];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = selectedCell.textLabel.text;
    
    [self handlePitbulAction: [pitbulActionProvider actionByTitle:title]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)handlePitbulAction:(PitbulAction *)pitbulAction {
    if (pitbulAction != nil && [SettingsUtils isSettingsConfigured]) {
        if (pitbulAction.type == CALL) {
            [self makeCallToRecipient:pitbulAction.action];
        } else if (pitbulAction.type == SMS) {
            NSString *phone = [SettingsUtils pitbulPhoneNumber];
            NSString *password = [SettingsUtils pitbulPassword];
            NSString *sms = [NSString stringWithFormat:@"%@{%@}", password, pitbulAction.action];
            
            [self sendSmsToRecipient:phone WithBody:sms];
        } else {
            NSLog(@"Unknown action detected: %@", pitbulAction);
        }
    }
}

- (void)makeCallToRecipient:(NSString *)recipient {
    NSLog(@"Call to: %@", recipient);
    NSString *phone = [NSString stringWithFormat:@"tel:%@", recipient];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

- (void)sendSmsToRecipient:(NSString *)recipient WithBody:(NSString *)body {
    if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
		controller.body = body;
		controller.recipients = [NSArray arrayWithObjects:recipient, nil];
		controller.messageComposeDelegate = self;
        
		[self presentViewController:controller animated:YES completion:nil];
	} else {
        [Utils errorDialogWithTitle:NSLocalizedString(@"error.sms.title", nil) andMessage:NSLocalizedString(@"error.sms.message.unableToSendSms", nil)];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	switch (result) {
        case MessageComposeResultFailed:
            NSLog(@"SMS is failed");
			break;
		case MessageComposeResultCancelled:
			NSLog(@"SMS is cancelled");
			break;
		case MessageComposeResultSent:
            NSLog(@"SMS is sent");
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
