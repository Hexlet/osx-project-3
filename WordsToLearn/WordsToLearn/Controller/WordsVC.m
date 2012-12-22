/**
* Created by undelalune on 27.11.12.
* version 0.1
* The main screen for the application.
**/

#import "WordsVC.h"
#import "AddUpdateVC.h"
#import "Word.h"
#import "StorageHelper.h"


@interface WordsVC ()
{
@private
    // temp array of words for current screen
    NSMutableArray *words;
    // an array of words for the Search view
    NSMutableArray *filteredWords;
}

@end

@implementation WordsVC

@synthesize mainTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([StorageHelper initStorage])
    {
        // init data
        words = [StorageHelper loadData];
        [[self tableView] reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    filteredWords = [[NSMutableArray alloc] init];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWords:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Learn" style:UIBarButtonItemStylePlain target:self action:@selector(startTest:)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

// Test button pressed. Go to the Test screen
- (void)startTest:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddUpdateVC *testVC = [storyboard instantiateViewControllerWithIdentifier:@"TestSB"];
    [testVC setModalPresentationStyle:UIModalPresentationFullScreen];

    [self.navigationController pushViewController:testVC animated:YES];
}

// Add button clicked. Go to the Add/Update screen
- (void)addWords:(id)sender
{
    [self gotoAddUpdateView:nil :[words count]];
}

// Go to the Add/Update screen and pass the word and its position
- (void)gotoAddUpdateView:(Word *)word:(int)forIndex
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddUpdateVC *addUpdateVC = [storyboard instantiateViewControllerWithIdentifier:@"AddUpdateSB"];
    addUpdateVC.word = word;
    addUpdateVC.wordIndex = forIndex;
    [addUpdateVC setModalPresentationStyle:UIModalPresentationFullScreen];

    [self.navigationController pushViewController:addUpdateVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section for current state.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        // search state
        return [filteredWords count];
    }
    return [words count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    Word *selectedWord = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        // search state
        selectedWord = [filteredWords objectAtIndex:(NSUInteger) indexPath.row];
    } else
    {
        selectedWord = [words objectAtIndex:(NSUInteger) indexPath.row];
    }
    cell.textLabel.text = [selectedWord word];
    cell.detailTextLabel.text = [selectedWord translation];

    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // search state
        if (tableView == self.searchDisplayController.searchResultsTableView)
        {
            // delete word from both arrays and update our storage
            Word *word = [filteredWords objectAtIndex:(NSUInteger) [indexPath row]];
            [filteredWords removeObjectAtIndex:(NSUInteger) [indexPath row]];
            [StorageHelper deleteWordAtPos:[words indexOfObject:word]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            words = [StorageHelper loadData];
            [mainTableView reloadData];
        } else
        {
            [StorageHelper deleteWordAtPos:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)viewDidUnload
{
    [self setMainTableView:nil];
    [words removeAllObjects];
    words = nil;
    [filteredWords removeAllObjects];
    filteredWords = nil;
    [super viewDidUnload];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Word was selected - go to Update screen
    Word *word = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        word = [filteredWords objectAtIndex:(NSUInteger) indexPath.row];
        [self.searchDisplayController setActive:NO animated:NO];
        [self gotoAddUpdateView:word :[words indexOfObject:word]];
    } else
    {
        word = [words objectAtIndex:(NSUInteger) indexPath.row];
        [self gotoAddUpdateView:word :indexPath.row];
    }
}

#pragma mark - UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // Search words by entered text
    [filteredWords removeAllObjects];
    for (Word *word in words)
    {
        if ([word.word rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound ||
                [word.translation rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [filteredWords addObject:word];
        }
    }
}

@end
