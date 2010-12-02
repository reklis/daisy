#import <Foundation/Foundation.h>

@interface NSError(AsyncHttpRequestError)

+ (NSError*) errorWithMessage:(NSString*)errorMessage;

@end

/** NSError userInfo key for messages */
extern NSString* kAsyncHttpRequestFailureMessageUserDictionaryInfoKey;

#pragma mark -

/** Abstract base class for NSURLConnection instances that are managed with NSOperationQueue */
@interface AsyncHttpRequest : NSOperation /* <NSURLConnectionDelegate> */
{
    @protected
    
    BOOL isDownloading;
    NSMutableURLRequest* urlRequest;
    NSURLConnection* urlConnection;
}

// NSURLConnection

@property (readonly) BOOL isDownloading;
@property (readwrite,nonatomic,retain) NSMutableData* downloadedData;

@property (readwrite,nonatomic,copy) NSString* username;
@property (readwrite,nonatomic,copy) NSString* password;

- (id) initWithURLString:(NSString*)urlString
                username:(NSString*)username
                password:(NSString*)password
                 timeout:(NSTimeInterval)timeoutIntervalInSeconds
             cachePolicy:(NSURLRequestCachePolicy)cachePolicy;

+ (NSString*) urlFromBase:(NSString*)baseUrl
              withOptions:(NSDictionary*)options;


// NSOperation

+ (NSOperationQueue*) sharedOperationQueue;

- (void) start;
- (void) cancel;

// Private

- (void) finishedDownloading;
- (void) completeWithError:(NSError*)error;

@end

