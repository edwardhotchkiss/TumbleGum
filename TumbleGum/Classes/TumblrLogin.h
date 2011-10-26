
#import <UIKit/UIKit.h>

@interface TumblrLogin : NSObject {
	id target;
	NSString *email;
	NSString *password;
	NSURLConnection *conn;
	NSMutableData *urlData;
}

@property(nonatomic, retain) NSURLConnection *conn; 
@property(nonatomic, retain) NSMutableData *urlData;

-(id)initWithTarget:(id)passedTarget email:(NSString *)passedEmail password:(NSString *)passedPassword;
-(void)validateTumblrCredentials;

@end