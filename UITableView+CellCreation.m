//
//  UITableView+CellCreation.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import "UITableView+CellCreation.h"

@implementation UITableView(CellCreation)

- (UITableViewCell*) dequeueCellWithStyle:(UITableViewCellStyle)cellStyle
{
    static NSString *cellId = @"UITableViewCell";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle
                                       reuseIdentifier:cellId] autorelease];
    }
    return cell;
}

- (UITableViewCell*) dequeueCell
{
    return [self dequeueCellWithStyle:UITableViewCellStyleDefault];
}

@end
