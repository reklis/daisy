#import "UIApplication+ErrorDialog.h"

@implementation UIApplication(ErrorDialog)

+ (void) displayError:(NSError*)error
{
    NSLog(@"%@", error);
    
    UIAlertView* errorDialog = [[[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                           message:[error localizedFailureReason]
                                                          delegate:nil
                                                 cancelButtonTitle:LS_OK
                                                 otherButtonTitles:nil] autorelease];
    [errorDialog show];    
}

@end

