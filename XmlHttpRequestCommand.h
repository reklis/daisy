#import <Foundation/Foundation.h>

#import "AsyncCommand.h"
#import "AsyncXmlHttpRequest.h"

@interface XmlHttpRequestCommand : AsyncCommand <AsyncXmlHttpRequestDelegate> {
    AsyncXmlHttpRequest* _req;
}

- (NSDictionary*) parameters;
- (NSString*) resourceURL;

#pragma mark Child Override Points

- (NSString*) baseURL;
- (NSDictionary*) parameters;

- (void) parseResultTotal:(NSDictionary*) data;
- (void) parseResult:(NSDictionary*) data;

@end
