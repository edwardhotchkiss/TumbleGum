
#import <UIKit/UIKit.h>

@interface LoadingModalView:UIView {
	UIActivityIndicatorView *spinner;
	UILabel *loadingLabel;
}

- (id)initWithFrame:(CGRect)frame labelText:(NSString *)passedLabelText;

@end