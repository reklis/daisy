//
//  NSBundle+LoadNibView.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle(LoadNibView)

+ (id) loadNibView:(NSString*)className;

@end