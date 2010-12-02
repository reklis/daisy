#import "UITableViewCell+Bindable.h"

@implementation UITableViewCell(Bindable)

- (void) bindModel:(NSDictionary*)data usingViewNibNamed:(NSString*)viewNib
{
    UIView* cv = self.contentView;
    if (cv.subviews.count == 0) {
        id<Bindable> v = [NSBundle loadNibView:viewNib];
        [v bindModel:data];
        [cv addSubview:v];
    } else {
        id<Bindable> v = [cv.subviews objectAtIndex:0];
        [v bindModel:data];
    }
}

@end
