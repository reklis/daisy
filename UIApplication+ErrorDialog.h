//
//  UIApplication+ErrorDialog.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication(ErrorDialog)

+ (void) displayError:(NSError*)error;

@end