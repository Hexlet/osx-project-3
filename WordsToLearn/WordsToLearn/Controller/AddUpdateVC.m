/**
* Created by undelalune on 27.11.12.
* version 0.1
* This is a screen where
* we are able to add new word or to update
* an existing one.
**/


#import "AddUpdateVC.h"
#import "Word.h"
#import "StorageHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface AddUpdateVC ()

@end


@implementation AddUpdateVC

@synthesize word, wordIndex, txtTranslation, txtWord;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

// hide keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// hide keyboard on Return key pressed
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self.txtTranslation resignFirstResponder];
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.txtTranslation.delegate self];
    [self.txtWord.delegate self];
    self.txtTranslation.layer.cornerRadius = 5;
    // update controls if this is update state
    if (word != nil)
    {
        [txtWord setText:[word word]];
        [txtTranslation setText:[word translation]];
    } else
    {
        word = [[Word alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// update words array in our storage
- (IBAction)saveHandler:(id)sender
{
    if (![txtWord.text isEqualToString:@""] && ![txtTranslation.text isEqualToString:@""])
    {
        [word setWord:[txtWord text]];
        [word setTranslation:[txtTranslation text]];

        [StorageHelper updateWord:word atPos:wordIndex];

        [self.navigationController popViewControllerAnimated:YES];
    }
}

// hide keyboard
- (IBAction)dismissKeyboard:(id)sender
{
    [self.txtTranslation resignFirstResponder];
    [self.txtWord resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setWord:nil];
    [self setTxtWord:nil];
    [self setTxtTranslation:nil];
    [super viewDidUnload];
}
@end
