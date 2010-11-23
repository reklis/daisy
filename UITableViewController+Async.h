//
//  UITableViewController+Async.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewController(DynamicDataSource)

- (void) changeDataSource:(id<UITableViewDataSource>)newDataSource;

@end
