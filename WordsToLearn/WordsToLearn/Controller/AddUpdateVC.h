/**
* Created by undelalune on 27.11.12.
* version 0.1
**/


#import <UIKit/UIKit.h>

@class Word;

@interface AddUpdateVC : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property(weak, nonatomic) IBOutlet UITextField *txtWord;
@property(weak, nonatomic) IBOutlet UITextView *txtTranslation;
@property(weak, nonatomic) IBOutlet UIButton *btnSave;

@property(strong, nonatomic) Word *word;
@property(assign, nonatomic) int wordIndex;

- (IBAction)saveHandler:(id)sender;

- (IBAction)dismissKeyboard:(id)sender;

@end
