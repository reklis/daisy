#import <UIKit/UIKit.h>

@interface EmptyDataSource : NSObject <UITableViewDataSource,UITableViewDelegate>
{
}

+ (id) emptyDataSource;

@end
