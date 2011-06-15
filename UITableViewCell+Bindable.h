#import <UIKit/UIKit.h>

@protocol Bindable <NSObject,NSCoding,UIAppearance, UIAppearanceContainer>

- (void) bindModel:(NSDictionary*)m;

@end

@interface UITableViewCell(Bindable)

- (void) bindModel:(NSDictionary*)data usingViewNibNamed:(NSString*)viewNib;

@end
