#import "LoadingDataSource.h"


@implementation LoadingDataSource

+ (id) loadingDataSource
{
    return [[[LoadingDataSource alloc] init] autorelease];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueCell];
    
    UIView* cv = cell.contentView;
    if (cv.subviews.count == 0) {
        [cv addSubview:[NSBundle loadNibView:@"LoadingCell"]];
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
