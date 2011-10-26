
#import "TumblrLogin.h"
#import "SettingsViewController.h"

@implementation TumblrLogin

@synthesize conn;
@synthesize urlData;

- (id)initWithTarget:(id)passedTarget email:(NSString *)passedEmail password:(NSString *)passedPassword {
	if ((self = [super init])) {
		target = passedTarget;
		email = [passedEmail copy];
		password = [passedPassword copy];
	}
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {  
    [urlData appendData:data];
}  

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[target loginMethodComplete:(@"fail")];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *responseString = [[[NSString alloc] initWithBytes:[urlData bytes] length:[urlData length] encoding:NSUTF8StringEncoding] autorelease];
	NSString *invalidCredentials = @"Invalid credentials.";
	if ([responseString isEqualToString:invalidCredentials]) {
		[target loginMethodComplete:(@"fail")];
	} else {
		[target loginMethodComplete:(@"success")];
	}
	[conn release];
    [urlData release];
}

-(void)validateTumblrCredentials {
	NSString *requestString = [NSString stringWithFormat:@"email=%@&password=%@",email,password]; 
	NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://www.tumblr.com/api/authenticate"]]; 
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
}

- (void) dealloc {
	[super dealloc];  
}

@end

