#import <Foundation/Foundation.h>

#import "AsyncHttpRequest.h"

@protocol AsyncXmlHttpRequestDelegate;

@interface AsyncXmlHttpRequest : AsyncHttpRequest <NSXMLParserDelegate>
{
    @private
    
    BOOL isParsing;
    NSXMLParser* xmlParser;
    NSMutableDictionary* parsedXmlData; // root element
    id currentParserElement;
    id parentElement;
    
    id<AsyncXmlHttpRequestDelegate> delegate;
}

+ (AsyncXmlHttpRequest*) queueRequest:(NSString*)urlString
                           withDelegate:(id<AsyncXmlHttpRequestDelegate>)delegate;

@property (readonly) BOOL isParsing;
@property (readwrite,nonatomic,assign) id<AsyncXmlHttpRequestDelegate> delegate; // weak reference


- (void) beginXmlParsing:(NSString*)urlString;
- (void) completeWithSuccess:(NSDictionary*)dictionary;

@end

#pragma mark -

@protocol AsyncXmlHttpRequestDelegate<NSObject>

@optional

- (void) request:(AsyncXmlHttpRequest*)request completedWithData:(NSDictionary*)data;
- (void) request:(AsyncXmlHttpRequest*)request completedWithError:(NSError*) error;

@end
