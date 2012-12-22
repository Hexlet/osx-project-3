/**
* Created by undelalune on 27.11.12.
* version 0.1
**/


#import <UIKit/UIKit.h>

@interface WordsVC : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property(strong, nonatomic) IBOutlet UITableView *mainTableView;

@end
