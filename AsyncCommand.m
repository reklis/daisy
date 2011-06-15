#import "AsyncCommand.h"

@implementation AsyncCommand

@synthesize delegate;
@synthesize lifespan;

- (id) init
{
    self = [super init];
    if (self != nil) {
        self.lifespan = 60; // default to 1 minute
        
        [self resetState];
    }
    return self;
}

- (void) resetState
{
    _isLoaded = NO;
    _isLoading = NO;
    _timeLoaded = 0;
}

- (BOOL) isLoaded
{
    return _isLoaded;
}

- (BOOL) isLoading
{
    return _isLoading;
}

- (BOOL) isExpired
{
    if (0 == _timeLoaded) {
        return YES;
    } else {
        NSTimeInterval delta = [[NSDate date] timeIntervalSinceReferenceDate] - _timeLoaded;
        return (delta >= self.lifespan);
    }
}

- (void) cancel
{
}

- (void) invalidate
{
    [self resetState];
}

- (void) load
{
}

- (void) didStartLoad
{
    _isLoaded = NO;
    _isLoading = YES;
    
    if ([delegate respondsToSelector:@selector(commandDidStart:)]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [delegate commandDidStart:self];
        });
    }
}

- (void) didCancelLoad
{
    [self resetState];
    
    if ([delegate respondsToSelector:@selector(commandDidCancelLoad:)]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [delegate commandDidCancelLoad:self];
        });
    }
}

- (void) didFailLoadWithError:(NSError*)error
{
    [self resetState];
    
    if ([delegate respondsToSelector:@selector(command:didFailLoadWithError:)]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [delegate command:self didFailLoadWithError:error];
        });
    }
}

- (void) didFinishLoad
{
    _isLoaded = YES;
    _isLoading = NO;
    _timeLoaded = [[NSDate date] timeIntervalSinceReferenceDate];

    if ([delegate respondsToSelector:@selector(commandDidFinishLoad:)]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [delegate commandDidFinishLoad:self];
        });
    }
}


@end
