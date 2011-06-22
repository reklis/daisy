#import <UIKit/UIKit.h>

@protocol Bindable <NSObject,NSCoding>

- (void) bindModel:(NSDictionary*)m;

@end

@interface UITableViewCell(Bindable)

- (void) bindModel:(NSDictionary*)data usingViewNibNamed:(NSString*)viewNib;

@end
