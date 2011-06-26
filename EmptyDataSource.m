#import "EmptyDataSource.h"


@implementation EmptyDataSource

+ (id) emptyDataSource
{
    return [[[EmptyDataSource alloc] init] autorelease];
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueCell];
    cell.textLabel.text = LS_EMPTYRESULTS;
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
