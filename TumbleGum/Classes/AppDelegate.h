
#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "MainViewController.h"

@interface AppDelegate:NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
	SettingsViewController *settingsViewController;
	MainViewController *mainViewController;
	LoadingModalView *loadingView;
	UINavigationController *parentNavigationController;
	NSUserDefaults *defaults;
}

-(void)showSystemFonts;

@property(retain) NSUserDefaults *defaults;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

