#import <UIKit/UIKit.h>

@interface UITableViewController(DynamicDataSource)

- (void) changeDataSource:(id<UITableViewDataSource,UITableViewDelegate>)newDataSource;

@end
