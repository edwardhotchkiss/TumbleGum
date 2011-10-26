
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"

@implementation MainViewController

@synthesize tumblrTitleField;
@synthesize tumblrBodyField;
@synthesize postPlaceHolderLabel;
@synthesize textFieldsHolder;
@synthesize interfaceOrientation;

-(id)init {
	if ((self = [super init])) {
		[self.view setBackgroundColor:[UIColor whiteColor]];
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	if (theTextField == tumblrTitleField) {
		[tumblrBodyField becomeFirstResponder];
	} else {
		[tumblrBodyField becomeFirstResponder];
	}
	return NO;
}

-(void)accountHandler {
	SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	[UIView beginAnimations:@"animation" context:nil];
	[self.navigationController pushViewController:settingsViewController animated:NO];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO]; 
	[UIView commitAnimations];
	[settingsViewController release];
}

- (void)postToTumblr {
	if ([tumblrBodyField.text isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Post" message: @"Your post cannot be left blank!" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
	} else {
		self.view.userInteractionEnabled = NO;
		loadingModalView = [[LoadingModalView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) labelText:@"Posting to Tumblr..."];
		loadingModalView.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) - 15);
		loadingModalView.alpha = 0;
		[self.view addSubview:loadingModalView];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[loadingModalView setAlpha:0.8];
		[UIView commitAnimations];
		tumblrPost = [[TumblrPost alloc] initWithPost:self];
		[tumblrPost postToTumblr:self postTitle:tumblrTitleField.text postBody:tumblrBodyField.text];
	}
}

-(void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title=@"TumbleGum";
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Account" style:UIBarButtonItemStyleBordered target:self action:@selector(accountHandler)];
	self.navigationItem.leftBarButtonItem = settingsButton;
	[settingsButton release];
	UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleDone target:self action:@selector(postToTumblr)];
	self.navigationItem.rightBarButtonItem = postButton;
	[postButton release];
	textFieldsHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
	[textFieldsHolder setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:textFieldsHolder];
	[self setupTumblrFields];
	UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 1)];
	UIColor *borderColor = [[UIColor alloc] initWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
	[borderView setBackgroundColor:borderColor];
	[textFieldsHolder addSubview:borderView];
	[borderView release];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([textView.text isEqualToString:@""]) {
		postPlaceHolderLabel.text = @"Post";
	}
}

-(void)textViewDidChange:(UITextView *)textView {
	if (![textView.text isEqualToString:@""]) {
		postPlaceHolderLabel.text = @"";
	} else {
		postPlaceHolderLabel.text = @"Post";
	}
}

-(void)setupTumblrFields {
	UIFont *tumblrPostingFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
	tumblrTitleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
	tumblrTitleField.keyboardType = UIKeyboardTypeDefault;
	tumblrTitleField.returnKeyType = UIReturnKeyNext;
	tumblrTitleField.textColor = [UIColor darkGrayColor];
	tumblrTitleField.placeholder = @"Title (optional)";
	tumblrTitleField.font = tumblrPostingFont;
	[tumblrTitleField setEnabled:YES];
	tumblrTitleField.delegate = self;
	[tumblrTitleField becomeFirstResponder];
	[textFieldsHolder addSubview:tumblrTitleField];
	postPlaceHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 43, 315, 30)];
	postPlaceHolderLabel.text = @"Post";
	postPlaceHolderLabel.font = tumblrPostingFont;
	postPlaceHolderLabel.textColor = [UIColor lightGrayColor];
	[textFieldsHolder addSubview:postPlaceHolderLabel];
	[postPlaceHolderLabel release];
	tumblrBodyField = [[UITextView alloc] initWithFrame:CGRectMake(3, 40, 315, 170)];
	[tumblrBodyField setBackgroundColor:[UIColor clearColor]];
	tumblrBodyField.keyboardType = UIKeyboardTypeDefault;
	tumblrBodyField.returnKeyType = UIReturnKeyDefault;
	tumblrBodyField.textColor = [UIColor darkGrayColor];
	tumblrBodyField.font = tumblrPostingFont;
	tumblrBodyField.delegate = self;
	[textFieldsHolder addSubview:tumblrBodyField];
}

-(void)removeModalView:(NSString*)animationID finished:(BOOL)finished context:(void *)context {
	[loadingModalView removeFromSuperview];
	loadingModalView = nil;
	if (passFail == @"success") {
		tumblrBodyField.textColor = [UIColor lightGrayColor];
		[tumblrTitleField setText:@""];
		[tumblrBodyField setText:@""];
		postPlaceHolderLabel.text = @"Post";
		[tumblrTitleField becomeFirstResponder];
		successView = [[UIAlertView alloc] initWithTitle:@"Success" message: @"Posted!" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[successView show];
		successView.tag = 47;
		[successView release];
	} else if (passFail == @"fail") {
		UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle: @"Error!" message: @"Error Posting, please try again" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[failAlert show];
		[failAlert release];
	}
}

-(void)postMethodComplete:(NSString *)passedPassFail {
	if (loadingModalView) {
		passFail = passedPassFail;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[loadingModalView setAlpha:0.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(removeModalView:finished:context:)];
		[UIView commitAnimations];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		self.view.userInteractionEnabled = YES;
	}
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
	[postPlaceHolderLabel release];
	[tumblrTitleField release];
	[tumblrBodyField release];
	[tumblrPost release];
	[textFieldsHolder dealloc];
	[passFail release];
    [super dealloc];
}

@end