/**
* Created by undelalune on 27.11.12.
* version 0.1
**/

#import <UIKit/UIKit.h>

@interface TestVC : UIViewController <UITextViewDelegate>

@property(weak, nonatomic) IBOutlet UILabel *txtWord;
@property(weak, nonatomic) IBOutlet UITextView *txtTranslation;
@property(weak, nonatomic) IBOutlet UITextView *txtOriginal;
@property(weak, nonatomic) IBOutlet UIButton *btnNext;
@property(weak, nonatomic) IBOutlet UIButton *btnDone;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)nextClickHandler:(id)sender;

- (IBAction)doneClickHandler:(id)sender;

- (void)showNextWord;

- (void)reverseTest;

@end
