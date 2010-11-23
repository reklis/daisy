//
//  NSBundle+LoadNibView.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import "NSBundle+LoadNibView.h"

@implementation NSBundle(LoadNibView)

+ (id) loadNibView:(NSString*)className
{
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] objectAtIndex:0];
}

@end