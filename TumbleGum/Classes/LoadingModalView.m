
#import <QuartzCore/QuartzCore.h>
#import "LoadingModalView.h"

@implementation LoadingModalView

- (id)initWithFrame:(CGRect)frame labelText:(NSString *)passedLabelText {
    if (self == [super initWithFrame:frame]) {
		[self setBackgroundColor:[UIColor blackColor]];
		self.layer.cornerRadius = 20;
		spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		spinner.center = CGPointMake((frame.size.width / 2.0), (frame.size.height / 2.0) - 25);
		[spinner startAnimating];
		[self addSubview:spinner];
		[spinner release];
		loadingLabel = [[UILabel alloc] init];
		loadingLabel.text = passedLabelText;
		loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
		[loadingLabel sizeToFit];
		loadingLabel.textColor = [UIColor whiteColor];
		loadingLabel.backgroundColor = [UIColor clearColor];
		loadingLabel.center = CGPointMake((frame.size.width / 2.0), (frame.size.height / 2.0) + 10);
		[self addSubview:loadingLabel];
		[loadingLabel release];
	};
	return self;	
}

- (void)dealloc {
	[spinner release];
    [super dealloc];
}

@end
