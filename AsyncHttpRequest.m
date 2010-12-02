#import "AsyncHttpRequest.h"


NSString* kAsyncHttpRequestFailureMessageUserDictionaryInfoKey = @"kAsyncHttpRequestFailureMessageUserDictionaryInfoKey";

@implementation NSError(AsyncHttpRequestError)

+ (NSError*) errorWithMessage:(NSString*)errorMessage {
    NSDictionary* userInfo = [NSDictionary dictionaryWithObject:errorMessage
                                                         forKey:kAsyncHttpRequestFailureMessageUserDictionaryInfoKey];
    NSError* error = [NSError errorWithDomain:@"AsyncXmlHttpRequest"
                                         code:0
                                     userInfo:userInfo];
    return error;
}

@end

@implementation AsyncHttpRequest

+ (NSOperationQueue*) sharedOperationQueue
{
    static NSOperationQueue* asyncHttpQueue = nil;
    @synchronized(asyncHttpQueue) {
        if (nil == asyncHttpQueue) {
            asyncHttpQueue = [[NSOperationQueue alloc] init];
            [asyncHttpQueue setName:@"AsyncHttpRequest"];
            [asyncHttpQueue setSuspended:NO];
        }
    }
    return asyncHttpQueue;
}

+ (NSString*) urlFromBase:(NSString*)baseUrl withOptions:(NSDictionary*)options
{
    NSMutableString* urlString = [NSMutableString stringWithString:baseUrl];
    int i = -1;
    for (NSString* k in [options allKeys]) {
        [urlString appendFormat:@"%@%@=%@", (++i==0) ? @"?" : @"&", k, [options objectForKey:k]];
    }
    return urlString;
}

- (id) initWithURLString:(NSString*)urlString
                username:(NSString*)u
                password:(NSString*)p
                 timeout:(NSTimeInterval)timeoutIntervalInSeconds
             cachePolicy:(NSURLRequestCachePolicy)cachePolicy
{
    self = [super init];
    if (self != nil) {
        self.username = u;
        self.password = p;
        
        NSURL* url = [NSURL URLWithString:urlString];
        
		urlRequest = [NSURLRequest requestWithURL:url
                                      cachePolicy:cachePolicy
                                  timeoutInterval:timeoutIntervalInSeconds];
        
		urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                        delegate:self];
        
        isDownloading = YES;
		
        if (urlConnection) {
			self.downloadedData = [NSMutableData data]; // retained by property
		} else {
            [self completeWithError:[NSError errorWithMessage:@"Failed to create NSURLConnection object"]];
		}
    }
    return self;
}

#pragma mark NSURLConnectionDelegate

@synthesize isDownloading, downloadedData;
@synthesize username, password;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    isDownloading = YES;
    
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
    [self.downloadedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection release];
	
	[self completeWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%@: Succeeded! Received %d bytes of data", self, [self.downloadedData length]);
	
    [connection release];
    
    isDownloading = NO;
    [self finishedDownloading];
}

//-(NSURLRequest *)connection:(NSURLConnection *)connection
//            willSendRequest:(NSURLRequest *)request
//           redirectResponse:(NSURLResponse *)redirectResponse
//{
//	NSLog(@"%@ URL Redirection: Connection: %@  Request: %@ Response: %@", self, connection, request, redirectResponse);
//	
//    NSURLRequest *newRequest=request;
//    if (redirectResponse) {
//        newRequest=nil;
//    }
//    return newRequest;
//}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge previousFailureCount] == 0) {
        NSURLCredential *newCredential;
        newCredential=[NSURLCredential credentialWithUser:self.username
                                                 password:self.password
                                              persistence:NSURLCredentialPersistencePermanent];
        [[challenge sender] useCredential:newCredential
               forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        
        // inform the user that the user name and password
        // in the preferences are incorrect
        //[self showPreferencesCredentialsAreIncorrectPanel:self];
        
        [self completeWithError:[challenge error]];
    }
}

//-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
//				 willCacheResponse:(NSCachedURLResponse *)cachedResponse
//{
//    //	NSCachedURLResponse *newCachedResponse=cachedResponse;
//    //	if ([[[[cachedResponse response] URL] scheme] isEqual:@"https"]) {
//    //		newCachedResponse=nil;
//    //	} else {
//    //		NSDictionary *newUserInfo;
//    //		newUserInfo=[NSDictionary dictionaryWithObject:[NSDate date]
//    //												forKey:@"Cached Date"];
//    //		newCachedResponse=[[[NSCachedURLResponse alloc]
//    //							initWithResponse:[cachedResponse response]
//    //							data:[cachedResponse data]
//    //							userInfo:newUserInfo
//    //							storagePolicy:[cachedResponse storagePolicy]]
//    //						   autorelease];
//    //	}
//    //	return newCachedResponse;
//    
//	
//	NSCachedURLResponse *newCachedResponse = cachedResponse;
//	newCachedResponse = nil;
//	return newCachedResponse;
//}

- (void) completeWithError:(NSError*)error
{
    isDownloading = NO;
}

- (void) finishedDownloading
{
    // Child Override Point - Default implementation does nothing
}


#pragma mark NSOperation

- (void) start
{
    NSLog(@"%@ %@", self, urlConnection);
    [urlConnection start];
}

- (void) cancel
{
    NSLog(@"%@ Cancelled", self);
    
    [urlConnection cancel];
    isDownloading = NO;
    
    [self completeWithError:[NSError errorWithMessage:@"Operation Aborted"]];
}

- (BOOL)isExecuting
{
    return isDownloading;
}

- (BOOL)isFinished
{
    return (isDownloading == NO);
}


@end
