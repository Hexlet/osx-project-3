//
//  HRCommentsTableController.m
//  HabraReader
//
//  Created by Sergey Starukhin on 20.12.12.
//  Copyright (c) 2012 Sergey Starukhin. All rights reserved.
//

#import "HRCommentsTableController.h"
#import "Comment+Description.h"

#define CELL_CONTENT_MARGIN 10.0f

@interface HRCommentsTableController ()
@property (nonatomic, strong) NSArray *commentsOfMessage;
@end

@implementation HRCommentsTableController

- (void)setMessage:(Message *)message {
    if (_message != message) {
        _message = message;
        self.commentsOfMessage = [[message.comments allObjects] sortedArrayUsingSelector:@selector(compare:)];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.commentsOfMessage count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Comment Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Comment *comment = [self.commentsOfMessage objectAtIndex:indexPath.row];
    cell.textLabel.text = comment.description;
    if ([comment countOfComments] != 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //UILabel *label = [cell viewWithTag:1];
    //label.text = [comment.publicationDate description];
    //UITextView *text = [cell viewWithTag:2];
    //text.text = comment.content;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    Message *messageToView = [self.commentsOfMessage objectAtIndex:indexPath.row];
    if ([messageToView countOfComments] != 0) {
        HRCommentsTableController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"Comments Table Controller"];
        next.message = messageToView;
        [self.navigationController pushViewController:next animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment *comment = [self.commentsOfMessage objectAtIndex:indexPath.row];
    NSString *text = comment.description;
    
    CGSize constraint = CGSizeMake(self.tableView.bounds.size.width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);

    return height + (CELL_CONTENT_MARGIN * 2);
}

- (IBAction)returnToPostViewer:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
