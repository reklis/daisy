#import "UITableViewController+Async.h"

@implementation UITableViewController(DynamicDataSource)

- (void) changeDataSource:(id<UITableViewDataSource,UITableViewDelegate>)newDataSource
{
    self.tableView.dataSource = newDataSource;
    self.tableView.delegate = newDataSource;
    [self.tableView reloadData];
}

@end
