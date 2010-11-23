//
//  UITableView+CellCreation.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(CellCreation)

- (UITableViewCell*) dequeueCell;
- (UITableViewCell*) dequeueCell:(NSString*)cellId withStyle:(UITableViewCellStyle)cellStyle;
- (UITableViewCell*) dequeueCellForView:(NSString*)bindableViewName withData:(NSDictionary*)data;

@end
