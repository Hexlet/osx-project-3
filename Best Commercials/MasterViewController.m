//
//  MasterViewController.m
//  Best Commercials
//
//  Created by herku on 12/3/12.
//  Copyright (c) 2012 Advert.Ge. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Cell.h"
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *listOfItems;
    NSMutableArray *listOfImages;
    NSInteger page;
}
@end

@implementation MasterViewController


- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    page = 1;
    

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    

    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
     
    [self.refreshControl addTarget:self
                            action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self getData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listOfItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    static NSString *simpleTableIdentifier = @"cell";
    
    cCell *cell = (cCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBackground.png"]];
    }
    
   

    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[listOfItems objectAtIndex:indexPath.row ] valueForKey:@"image"] ]]];

    
    cell.nameLabel.text = [[listOfItems objectAtIndex:indexPath.row ]  valueForKey:@"name"];
    cell.brandLabel.text = [[listOfItems objectAtIndex:indexPath.row ]  valueForKey:@"brand"];
    cell.thumbImageView.image = image;


    cell.thumbImageView.layer.masksToBounds = YES;
    cell.thumbImageView.layer.cornerRadius = 5.0;
    cell.thumbImageView.layer.borderWidth = 2.0;
    cell.thumbImageView.layer.borderColor = [[UIColor blackColor] CGColor];

    
    //NSString *object =   [[listOfItems objectAtIndex:indexPath.row ]  valueForKey:@"name"];
    
    //NSString *imageUrl = [[listOfItems objectAtIndex:indexPath.row ]  valueForKey:@"image"];
    
   // NSURL *url = [NSURL URLWithString:imageUrl];
  
    
    
    //cell.textLabel.text = [object description];
    //cell.detailTextLabel.text = [[listOfItems objectAtIndex:indexPath.row ]  valueForKey:@"name"];
    //cell.imageView.image = [UIImage imageNamed:[[listOfItems objectAtIndex:indexPath.row ]  valueForKey:@"image"]];
    
   // cell.imageView.image = [UIImage imageNamed:@"MyReallyCoolImage.png"];
    return cell;
    
    }



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    
    if (maximumOffset - currentOffset <= -40) {
        page++;
        NSLog(@"reload %i", page );
        [self getMoreData];
        
        CGPoint point = [self.tableView contentOffset];
        float deceleration = [self.tableView decelerationRate];
        [self.tableView reloadData];
        [self.tableView setContentOffset:point];
        [self.tableView setDecelerationRate:deceleration];
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
   
   [self performSegueWithIdentifier:@"showDetail" sender:nil];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = [[listOfItems objectAtIndex:indexPath.row ]  valueForKey:@"url"];
        [[segue destinationViewController] setDetailItem:object];
    }
}



-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
 
    [self getData];
 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
     refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
     [refresh endRefreshing];
 }
- (IBAction)refresh:(id)sender{

}

- (void)getMoreData {
    
    NSString *url=[NSString stringWithFormat:@"http://www.advert.ge/api/page/%i", page];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
    
    //    NSString * theString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    //    NSLog(@"response: %@", theString);
    
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: &err];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", err);
    } else {
        
        //listOfItems = [[NSMutableArray alloc] init];
        
        for (NSDictionary *item in jsonArray){
            
            
            NSString *name =  [item valueForKey:@"name"];
            NSString *brand = [item valueForKey:@"brand"];
            NSString *image = [NSString stringWithFormat:@"http://www.advert.ge/videos/%@/thumb.jpg",[item valueForKey:@"filename"]];
            NSString *url = [NSString stringWithFormat:@"http://www.advert.ge/api/getcommercial/%@/",[item valueForKey:@"id"]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            [dict setObject:name forKey:@"name"];
            [dict setObject:brand forKey:@"brand"];
            [dict setObject:image forKey:@"image"];
            [dict setObject:url forKey:@"url"];
            
            [listOfItems addObject:dict];
            
            
        }
    }
    
    
    
    
}

- (void)getData {
    
    
    NSString *url=@"http://www.advert.ge/api/";
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLResponse *resp = nil;
    NSError *err = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest: theRequest returningResponse: &resp error: &err];
    
    //    NSString * theString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    //    NSLog(@"response: %@", theString);
    
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: &err];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", err);
    } else {

        listOfItems = [[NSMutableArray alloc] init];
                      
        for (NSDictionary *item in jsonArray){
            
             
            NSString *name =  [item valueForKey:@"name"];
            NSString *brand = [item valueForKey:@"brand"];
            NSString *image = [NSString stringWithFormat:@"http://www.advert.ge/videos/%@/thumb.jpg",[item valueForKey:@"filename"]];
            NSString *url = [NSString stringWithFormat:@"http://www.advert.ge/api/getcommercial/%@/",[item valueForKey:@"id"]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            [dict setObject:name forKey:@"name"];
            [dict setObject:brand forKey:@"brand"];
            [dict setObject:image forKey:@"image"];
            [dict setObject:url forKey:@"url"];
                       
            [listOfItems addObject:dict];
            



            
        }
    }
    
    


}

@end
