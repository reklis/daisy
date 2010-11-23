//
//  UITableViewCell+Bindable.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import "UITableViewCell+Bindable.h"

@implementation UITableViewCell(Bindable)

- (void) bindModel:(NSDictionary*)data usingViewNibNamed:(NSString*)viewNib
{
    UIView* cv = self.contentView;
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
