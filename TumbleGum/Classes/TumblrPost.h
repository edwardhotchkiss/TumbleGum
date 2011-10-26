
#import <UIKit/UIKit.h>

@interface TumblrPost : NSObject {
	id target;
	NSURLConnection *conn;
	NSMutableData *urlData;
}

-(id)initWithPost:(id)passedTarget;
-(id)postToTumblr:(id)passedTarget postTitle:(NSString *)passedPostTitle postBody:(NSString *)passedPostBody;

@property(nonatomic, retain) NSURLConnection *conn; 
@property(nonatomic, retain) NSMutableData *urlData;

@end