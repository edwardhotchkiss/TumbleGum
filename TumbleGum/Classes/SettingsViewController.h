
#import <UIKit/UIKit.h>
#import "LoadingModalView.h"
#import "TumblrLogin.h"
#import "LoadingModalView.h"
#import "MainViewController.h"
#import "SettingsViewController.h"

@interface SettingsViewController:UITableViewController <UITextFieldDelegate> {
	UITextField *emailField;
	UITextField *passwordField;
	UIButton *saveButton;
	LoadingModalView *loadingView;
	TumblrLogin *tumblrLogin;
	NSUserDefaults *defaults;
	UIAlertView *successView;
	NSString *passFail;
	UILabel *projectByEdward;
	UIInterfaceOrientation interfaceOrientation;
	UISegmentedControl *signupButton;
}

- (void)loginMethodComplete:(NSString *)passFail;

@property(retain) NSUserDefaults *defaults;
@property (nonatomic, retain) UIAlertView *successView;
@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UILabel *projectByEdward;
@property (nonatomic, readonly) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic, retain) UISegmentedControl *signupButton;

@end