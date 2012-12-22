/**
* Created by undelalune on 27.11.12.
* version 0.1
* This is a screen where we are able to
* check our knowledge ( translate words )
**/

#import "TestVC.h"
#import "StorageHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface TestVC ()
{
@private
    // temp array of words for current screen
    NSMutableArray *words;
    Word *currentWord;
    int wordIndex;
    // this flag is used to know which workflow is being used right now
    BOOL wordToTranslation;
}
@end


@implementation TestVC

@synthesize btnDone, btnNext, txtOriginal, txtTranslation, txtWord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // gets all the existing data from the storage
    words = [StorageHelper loadData];

    // shows an alert message if we don't have any word
    if ([words count] == 0)
    {
        [txtOriginal setHidden:YES];
        [txtTranslation setHidden:YES];
        [txtWord setHidden:YES];
        [btnDone setHidden:YES];
        [btnNext setHidden:YES];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Go back and add some words in your dictionary firstly." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        return;
    }

    wordIndex = 0;
    [self.txtTranslation.delegate self];
    self.txtTranslation.layer.cornerRadius = 5;
    [self shuffleArray];
    [self showNextWord];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reverse" style:UIBarButtonItemStylePlain target:self action:@selector(reverseTest)];
}

// Changes the test workflow language 1 <-> language 2
- (void)reverseTest
{
    wordToTranslation = !wordToTranslation;
    [self showNextWord];
}

// hide keyboard
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self.txtTranslation resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setTxtWord:nil];
    [self setTxtTranslation:nil];
    [self setBtnNext:nil];
    [self setTxtOriginal:nil];
    [self setBtnDone:nil];
    [super viewDidUnload];
}

// cleans up text fields and shows the next word
- (IBAction)nextClickHandler:(id)sender
{
    [txtOriginal setText:@""];
    [txtTranslation setText:@""];
    [self showNextWord];
}

// shows original translation for the current word
- (IBAction)doneClickHandler:(id)sender
{
    [txtOriginal setText:wordToTranslation ? [currentWord translation] : [currentWord word]];
}

// shows next word in the stack ( or shuffles words array and starts from the beginning
- (void)showNextWord
{
    if ([words count] > wordIndex)
    {
        currentWord = [words objectAtIndex:(NSUInteger) wordIndex];
        [txtWord setText:wordToTranslation ? [currentWord word] : [currentWord translation]];
        wordIndex++;
    } else
    {
        wordIndex = 0;
        [self shuffleArray];
        [self showNextWord];
    }
}
// hide keyboard
- (IBAction)dismissKeyboard:(id)sender
{
    [self.txtTranslation resignFirstResponder];
}

- (void)shuffleArray
{
    NSUInteger count = [words count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [words exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}
@end
