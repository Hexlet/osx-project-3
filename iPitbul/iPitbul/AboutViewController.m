//
//  FlipsideViewController.m
//  iPitbul
//
//  Created by Mykhailo Oleksiuk on 11/21/12.
//  Copyright (c) 2012 Mykhailo Oleksiuk. All rights reserved.
//

#import "AboutViewController.h"
#import "SystemUtils.h"
#import "Utils.h"

@interface AboutViewController ()

@end

@implementation AboutViewController {
    NSArray *actions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _labelVersion.text = [_labelVersion.text stringByAppendingString:[SystemUtils appicationVersion]];
    
    actions = [[NSArray alloc] initWithObjects:
                    NSLocalizedString(@"about.view.table.action.legalAndPrivcy", nil),
                    NSLocalizedString(@"about.view.table.action.tellFriends", nil),
                    NSLocalizedString(@"about.view.table.action.emailSupport", nil),
                    nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self.delegate aboutViewControllerDidFinish:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [actions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [actions objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [Utils errorDialogWithTitle:@"TODO" andMessage:@"Legal & Privacy View will be shown"];
            break;
        case 1:
            [self sendEmailToRecipient:nil
                           withSubject:NSLocalizedString(@"about.view.email.subject.tellFriends", nil)
                               andBody:NSLocalizedString(@"about.view.email.body.tellFriends", nil)];
            break;
        case 2:
            [self sendEmailToRecipient:@"mykhailo.oleksiuk@gmail.com"
                           withSubject:NSLocalizedString(@"about.view.email.subject.emailSupport", nil)
                               andBody:[NSString stringWithFormat:NSLocalizedString(@"about.view.email.body.emailSupport", nil),
                                        [SystemUtils applicationNameWithVersion], [SystemUtils device], [SystemUtils iOSVersion]]];
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sendEmailToRecipient:(NSString *)recipient withSubject:(NSString *)subject andBody:(NSString *)body {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        
        if ([recipient length] != 0) {
            [mailController setToRecipients:[NSArray arrayWithObject:recipient]];
        }
        
        [mailController setSubject:subject];
        [mailController setMessageBody:body isHTML:YES];
        
        [self presentViewController:mailController animated:YES completion:nil];
    } else {
        [Utils errorDialogWithTitle:NSLocalizedString(@"error.email.title", nil) andMessage:NSLocalizedString(@"error.email.message.unableToSendEmail", nil)];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultFailed:
            [Utils errorDialogWithTitle:NSLocalizedString(@"error.email.title", nil) andMessage:NSLocalizedString(@"error.email.message.unableToSendEmail", nil)];
            break;
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultSent:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
