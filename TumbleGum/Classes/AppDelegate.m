
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize defaults;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	UIWindow *tempWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = tempWindow;
	[tempWindow release];
	NSString *prefsEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"TumblrEmailAddress"];
	UIColor *purpleDrank = [[UIColor alloc] initWithRed:95.0/255.0 green:81.0/255.0 blue:162.0/255.0 alpha:1];
	if (prefsEmail == NULL) {
		settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
		navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
		navigationController.navigationBar.tintColor = purpleDrank;
		[window setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
		[window addSubview:navigationController.view];
		[window makeKeyAndVisible];
	} else {
		mainViewController = [[MainViewController alloc] init];
		navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
		navigationController.navigationBar.tintColor = purpleDrank;
		[window setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
		[window addSubview:navigationController.view];
		[purpleDrank release];
		[window makeKeyAndVisible];
	}
}

-(void)showSystemFonts {
	for (NSString *family in [UIFont familyNames]) {
		NSLog(@"%@", [UIFont fontNamesForFamilyName:family]);
	}
}

- (void)dealloc {
    [window release];
    [super dealloc];
}

@end
