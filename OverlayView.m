#import "OverlayView.h"


@implementation OverlayView

@synthesize textLabel;
@synthesize activityIndicator;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


+ (id) overlayWithText:(NSString*)title overView:(UIView*)coveredView
{
    OverlayView* v = [NSBundle loadNibView:@"OverlayView"];
    v.textLabel.text = title;
    
    [coveredView.superview insertSubview:v aboveSubview:coveredView];
    
    [v.activityIndicator startAnimating];
    v.alpha = 0;
    
    [UIView beginAnimations:kAnimationOverlayFadeIn context:NULL];
    [UIView setAnimationDuration:kOverlayFadeDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(animationWillStart:context:)];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    v.alpha = 1;
    
    [UIView commitAnimations];
    
    return v;
}

- (IBAction) dismiss
{
    [activityIndicator stopAnimating];
    
    [UIView beginAnimations:kAnimationOverlayFadeIn context:NULL];
    [UIView setAnimationDuration:kOverlayFadeDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(animationWillStart:context:)];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.alpha = 0;
    
    [UIView commitAnimations];    
}

#pragma mark UIView Animation

- (void) animationWillStart:(NSString *)animationID context:(void *)context
{
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:kAnimationOverlayFadeOut]) {
        [self removeFromSuperview];
    }
}


@end
