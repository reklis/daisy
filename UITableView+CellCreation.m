#import "UITableView+CellCreation.h"

@implementation UITableView(CellCreation)

- (UITableViewCell*) dequeueCell:(NSString*)cellId withStyle:(UITableViewCellStyle)cellStyle
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle
                                       reuseIdentifier:cellId] autorelease];
    }
    return cell;
}

- (UITableViewCell*) dequeueCell
{
    return [self dequeueCell:@"UITableViewCell" withStyle:UITableViewCellStyleDefault];
}

- (UITableViewCell*) dequeueCellForView:(NSString*)bindableViewName withData:(NSDictionary*)data
{
    UITableViewCell* cell = [self dequeueCell:bindableViewName withStyle:UITableViewCellStyleDefault];
    [cell bindModel:data usingViewNibNamed:bindableViewName];
    return cell;
}

@end
