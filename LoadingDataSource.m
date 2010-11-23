//
//  LoadingDataSource.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

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

@end
