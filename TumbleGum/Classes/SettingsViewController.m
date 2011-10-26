
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize emailField;
@synthesize passwordField;
@synthesize defaults;
@synthesize successView;
@synthesize signupButton;
@synthesize projectByEdward;
@synthesize interfaceOrientation;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		[[self tableView] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
		self.tableView.rowHeight = 40.0;
    }
    return self;
}

-(void)viewDidLoad {
	if (self) {
		UIEdgeInsets inset = UIEdgeInsetsMake(10, 0, 0, 0);
		self.tableView.contentInset = inset;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)backBtnUserClicked:(id)object {
	MainViewController *mainViewController = [[MainViewController alloc] init];
	[UIView beginAnimations:@"animation" context:nil];
	[self.navigationController pushViewController:mainViewController animated:NO];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration: 0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO]; 
	[UIView commitAnimations];
	[mainViewController release];
}

-(void)viewWillAppear:(BOOL)animated {
	self.navigationItem.title=@"Account";
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStyleBordered target:self action:@selector(backBtnUserClicked:)];
	self.navigationItem.leftBarButtonItem = settingsButton;
	[settingsButton release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		NSString *credentialsHeader = @"Tumblr Login";
		return credentialsHeader;
	} else if (section == 1) {
		NSString *signupHeader = @"Don't have an account?";
		return signupHeader;
	} else {
		return nil;
	}
}

- (void)loginMethod {
	self.view.userInteractionEnabled = NO;
	loadingView = [[LoadingModalView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) labelText:@"Logging in..."];
	loadingView.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) - 15);
	loadingView.alpha = 0;
	[self.view addSubview:loadingView];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[loadingView setAlpha:0.8];
	[UIView commitAnimations];
	tumblrLogin = [[TumblrLogin alloc] initWithTarget:self email:emailField.text password:passwordField.text];
	[tumblrLogin validateTumblrCredentials];
}

-(void)saveUserData {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:emailField.text forKey:@"TumblrEmailAddress"];
	[prefs setObject:passwordField.text forKey:@"TumblrPassword"];
	[prefs synchronize];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alertView == successView) {
		[self backBtnUserClicked:self];
	}
}

- (void)removeModalView:(NSString*)animationID finished:(BOOL)finished context:(void *)context {
	[loadingView removeFromSuperview];
	loadingView = nil;
	if (passFail == @"success") {
		[self saveUserData];
		successView = [[UIAlertView alloc] initWithTitle: @"Success" message: @"User information saved!" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[successView show];
		successView.tag = 45;
		[successView release];
	} else if (passFail == @"fail") {
		UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"User information invalid. Please re-enter information!" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
		[failAlert show];
		[failAlert release];
	}
}

- (void)loginMethodComplete:(NSString *)passedPassFail {
	if (loadingView) {
		passFail = passedPassFail;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[loadingView setAlpha:0.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(removeModalView:finished:context:)];
		[UIView commitAnimations];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		self.view.userInteractionEnabled = YES;
	}
}

-(void)signup {
	NSURL *tumblrURL = [NSURL URLWithString:@"http://www.tumblr.com/"];
	if (![[UIApplication sharedApplication] openURL:tumblrURL]) {
		NSLog(@"Failed to open URL");
	}

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else {
		return 1;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	if (theTextField == emailField) {
		[passwordField becomeFirstResponder];
	} else {
		[passwordField resignFirstResponder];
		if ([emailField.text length] == 0 || [passwordField.text length] == 0) {
			if ([emailField.text length] == 0 && [passwordField.text length] == 0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Login Information" message: @"Both your Email address and your Password cannot be left blank" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
				[alert show];
				[alert release];
				return YES;
			} else if ([emailField.text length] == 0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Login Information" message: @"Your Email address cannot be left blank" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
				[alert show];
				[alert release];
				return YES;
			} else if ([passwordField.text length] == 0) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Login Information" message: @"Your Password cannot be left blank" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
				[alert show];
				[alert release];
				return YES;
			}
		} else {
			[theTextField resignFirstResponder];
			[self loginMethod];
			return YES;
		}
	}
	return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		if ([indexPath section] == 0) {
			cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
			if ([indexPath row] == 0) {
				emailField = [[UITextField alloc] initWithFrame:CGRectMake(140, 10, 155, 30)];
				emailField.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
				emailField.keyboardType = UIKeyboardTypeEmailAddress;
				emailField.returnKeyType = UIReturnKeyNext;
				emailField.autocorrectionType = UITextAutocorrectionTypeNo;
				emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				emailField.textAlignment = UITextAlignmentRight;
				emailField.tag = 0;
				emailField.textColor = [UIColor darkGrayColor];
				emailField.placeholder = @"example@gmail.com";
				emailField.clearButtonMode = UITextFieldViewModeNever;
				emailField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"TumblrEmailAddress"];
				[emailField setEnabled: YES];
				emailField.delegate = self;	
				[cell addSubview:emailField];
				cell.textLabel.text = @"Email Address";
			} else if ([indexPath row] == 1) {
				passwordField = [[UITextField alloc] initWithFrame:CGRectMake(140, 10, 155, 30)];
				passwordField.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
				passwordField.keyboardType = UIKeyboardTypeDefault;
				passwordField.returnKeyType = UIReturnKeyGo;
				passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
				passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
				passwordField.textAlignment = UITextAlignmentRight;
				passwordField.tag = 1;	
				passwordField.textColor = [UIColor darkGrayColor];
				passwordField.placeholder = @"***********";
				[passwordField setSecureTextEntry:YES];
				passwordField.clearButtonMode = UITextFieldViewModeNever;
				passwordField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"TumblrPassword"];
				[passwordField setEnabled: YES];
				passwordField.delegate = self;
				[cell addSubview:passwordField];
				cell.textLabel.text = @"Password";
			}
		} else if ([indexPath section] == 1) {
			if ([indexPath row] == 0) {
				cell.backgroundColor = [UIColor clearColor];
				signupButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@""]];
				signupButton.frame = CGRectMake(10, 0, 300, 42);
				UIColor *purpleDrank = [[UIColor alloc] initWithRed:95.0/255.0 green:81.0/255.0 blue:162.0/255.0 alpha:0];
				signupButton.tintColor = purpleDrank;
				[signupButton addTarget:self action:@selector(signup) forControlEvents:UIControlEventValueChanged];
				signupButton.segmentedControlStyle = UISegmentedControlStyleBar;
				signupButton.momentary = YES;
				UILabel *loginLabel = [[UILabel alloc] initWithFrame:signupButton.frame];
				loginLabel.text = @"Signup for Tumblr";
				loginLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
				loginLabel.textAlignment = UITextAlignmentCenter;
				loginLabel.textColor = [UIColor whiteColor];
				loginLabel.backgroundColor = [UIColor clearColor];
				loginLabel.shadowColor = [UIColor darkGrayColor];
				loginLabel.shadowOffset = CGSizeMake(0, 1);
				[cell addSubview:signupButton];
				[cell addSubview:loginLabel];
				[purpleDrank release];
			}
		}
	}
	return cell;  
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)dealloc {
    [super dealloc];
}

@end