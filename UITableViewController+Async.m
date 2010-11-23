//
//  UITableViewController+Async.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import "UITableViewController+Async.h"

@implementation UITableViewController(DynamicDataSource)

- (void) changeDataSource:(id<UITableViewDataSource>)newDataSource
{
    self.tableView.dataSource = newDataSource;
    [self.tableView reloadData];
}

@end

@implementation UITableViewController(CellPopulation)

- (void) populateCell:(UITableViewCell*)cell withData:(NSDictionary*)data usingViewNibNamed:(NSString*)viewNib;
{
    UIView* cv = cell.contentView;
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

