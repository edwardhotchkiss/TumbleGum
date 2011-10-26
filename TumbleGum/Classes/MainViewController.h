
#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SettingsViewController.h"
#import "LoadingModalView.h"
#import "TumblrPost.h"

@interface MainViewController:UIViewController <UITextFieldDelegate, UITextViewDelegate> {
	UITextField *tumblrTitleField;
	UITextView *tumblrBodyField;
	UILabel *postPlaceHolderLabel;
	UIView *textFieldsHolder;
	LoadingModalView *loadingModalView;
	TumblrPost *tumblrPost;
	UIAlertView *successView;
	NSString *passFail;
	UIInterfaceOrientation *interfaceOrientation;
}

-(void)setupTumblrFields;
-(void)postMethodComplete:(NSString *)passedPassFail;

@property (nonatomic, retain) UITextField *tumblrTitleField;
@property (nonatomic, retain) UITextView *tumblrBodyField;
@property (nonatomic, retain) UILabel *postPlaceHolderLabel;
@property (nonatomic, retain) UIView *textFieldsHolder;
@property (nonatomic, readonly) UIInterfaceOrientation *interfaceOrientation;

@end