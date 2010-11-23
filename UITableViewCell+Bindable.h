//
//  UITableViewCell+Bindable.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Bindable <NSObject,NSCoding>

- (void) bindModel:(NSDictionary*)m;

@end

@interface UITableViewCell(Bindable)

- (void) bindModel:(NSDictionary*)data usingViewNibNamed:(NSString*)viewNib;

@end
