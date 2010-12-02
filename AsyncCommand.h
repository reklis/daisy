#import <Foundation/Foundation.h>

@protocol AsyncCommandDelegate;

@interface AsyncCommand : NSObject
{
    @protected
    
    BOOL _isLoaded;
    BOOL _isLoading;
    BOOL _isLoadingMore;
    
    NSTimeInterval _timeLoaded;
    NSTimeInterval expires;
}

/** Time in seconds the command results are valid */
@property (readwrite,nonatomic,assign) NSTimeInterval lifespan;

@property (readonly,nonatomic) BOOL isLoaded;
@property (readonly,nonatomic) BOOL isLoading;
@property (readonly,nonatomic) BOOL isExpired;

@property (readwrite,nonatomic,assign) id<AsyncCommandDelegate> delegate; // weak reference

- (void) resetState;

- (void) load; // default implementation does nothing

- (void) cancel;

- (void) invalidate;

// delegate signals

- (void) didStartLoad;
- (void) didCancelLoad;
- (void) didFailLoadWithError:(NSError*)error;
- (void) didFinishLoad;

@end


@protocol AsyncCommandDelegate <NSObject>

@optional

- (void)commandDidStart:(AsyncCommand*)command;

- (void)commandDidFinishLoad:(AsyncCommand*)command;

- (void)command:(AsyncCommand*)command didFailLoadWithError:(NSError*)error;

- (void)commandDidCancelLoad:(AsyncCommand*)command;

@end
