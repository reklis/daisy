//
//  EmptyDataSource.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

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

@end