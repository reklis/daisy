//
//  UITableViewController+Async.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Bindable <NSObject,NSCoding>

- (void) bindModel:(NSDictionary*)m;

@end

@interface UITableViewController(DynamicDataSource)

- (void) changeDataSource:(id<UITableViewDataSource>)newDataSource;

@end

@interface UITableViewController(CellPopulation)

- (void) populateCell:(UITableViewCell*)cell withData:(NSDictionary*)data usingViewNibNamed:(NSString*)viewNib;

@end
