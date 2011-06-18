//
//  NSObject+NSArray.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 6/17/11.
//  Copyright 2011 Cibo Technology, LLC. All rights reserved.
//

#import "NSObject+NSArray.h"

@implementation NSObject (NSObject_NSArray)

- (NSArray*) toArray
{
    if ([self isKindOfClass:[NSArray class]]) {
        return (NSArray*) self;
    } else {
        return [NSArray arrayWithObject:self];
    }
}

@end
