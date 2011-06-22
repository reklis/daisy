#import "AsyncCommandResponse.h"


@implementation AsyncCommandResponse

@synthesize responseData;

+ (id) resultFromData:(NSDictionary *)data
{
    AsyncCommandResponse* r = [[[[self class] alloc] init] autorelease];
    [r setResponseData:data];
    return r;
}

- (void)dealloc {
    [responseData release];
    [super dealloc];
}

@end
