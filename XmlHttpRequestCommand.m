#import "XmlHttpRequestCommand.h"


@implementation XmlHttpRequestCommand

- (void)dealloc {
    if (_req) {
        [_req release];
        _req = nil;
    }
    [super dealloc];
}

- (NSString*) resourceURL
{
    return [AsyncXmlHttpRequest urlFromBase:[self baseURL] withOptions:self.parameters];
}

- (void) load
{
    if (!self.isLoading) {
        NSString* u = [self resourceURL];
        if (nil != u) {
            _req = [[AsyncXmlHttpRequest queueRequest:self.resourceURL
                                          withDelegate:self] retain];
            
            [super didStartLoad];
        }
    }
}

- (void)cancel
{
    [_req cancel];
    
    [super didCancelLoad];
}

- (void)invalidate
{
    if (_req) {
        [self cancel];
        [_req release];
        _req = nil;
    }
    
    [super invalidate];
}

#pragma mark AsyncXmlHttpRequestDelegate

- (void) request:(AsyncXmlHttpRequest*)request completedWithData:(NSDictionary*)data
{
    @try {
        NSLog(@"success: %@", data);
        [self parseResultTotal:data];
        [self parseResult:data];
        
        [super didFinishLoad];
    }
    @catch (NSException * ex) {
        NSLog(@"%@",ex);
    }
    @finally {
        [_req release];
        _req = nil;
    }
}

- (void) request:(AsyncXmlHttpRequest*)request completedWithError:(NSError*) error
{
    @try {
        [super didFailLoadWithError:error];
    }
    @catch (NSException *ex) {
        NSLog(@"%@",ex);
    }
    @finally {
        [_req release];
        _req = nil;
    }
}

#pragma mark Child Override Points

- (NSString*) baseURL
{
    return nil;
}

- (NSDictionary*) parameters
{
    return nil;
}

- (void) parseResultTotal:(NSDictionary*) data
{
}

- (void) parseResult:(NSDictionary*) data
{
}

@end
