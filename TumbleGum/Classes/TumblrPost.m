
#import "TumblrPost.h"
#import "SettingsViewController.h"

@implementation TumblrPost

@synthesize conn;
@synthesize urlData;

- (id)initWithPost:(id)passedTarget {
	if ((self = [super init])) {
		target = passedTarget;
	}
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {  
    [urlData appendData:data];
}  

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[target postMethodComplete:(@"fail")];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [[[NSString alloc] initWithBytes:[urlData bytes] length:[urlData length] encoding:NSUTF8StringEncoding] autorelease];
	NSString *invalidCredentials = @"Invalid credentials.";
	if ([responseString isEqualToString:invalidCredentials]) {
		[target postMethodComplete:(@"fail")];
	} else {
		[target postMethodComplete:(@"success")];
	}
	[conn release];
    [urlData release];
}

-(id)postToTumblr:(id)passedTarget postTitle:(NSString *)passedPostTitle postBody:(NSString *)passedPostBody {
	NSString *postType = @"regular";
	NSString *generator = @"TumbleGum";
	NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"TumblrEmailAddress"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"TumblrPassword"];
	NSString *requestString = [NSString stringWithFormat:@"email=%@&password=%@&type=%@&title=%@&body=%@&generator=%@",email,password,postType,passedPostTitle,passedPostBody,generator]; 
	NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.tumblr.com/api/write"]]; 
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: requestData];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	[request release];
	if (conn == nil) { 
		self.urlData = nil; 
	} else {
		self.urlData = [NSMutableData data];
	}
	return nil;
}

- (void) dealloc {
	[super dealloc];  
}

@end

