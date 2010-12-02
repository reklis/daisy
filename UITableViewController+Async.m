//
//  UITableViewController+Async.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import "UITableViewController+Async.h"

@implementation UITableViewController(DynamicDataSource)

- (void) changeDataSource:(id<UITableViewDataSource,UITableViewDelegate>)newDataSource
{
    self.tableView.dataSource = newDataSource;
    self.tableView.delegate = newDataSource;
    [self.tableView reloadData];
}

@end
