#import <UIKit/UIKit.h>

@interface UITableView(CellCreation)

- (UITableViewCell*) dequeueCell;
- (UITableViewCell*) dequeueCell:(NSString*)cellId withStyle:(UITableViewCellStyle)cellStyle;
- (UITableViewCell*) dequeueCellForView:(NSString*)bindableViewName withData:(NSDictionary*)data;

@end
