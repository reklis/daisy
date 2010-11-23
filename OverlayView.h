//
//  OverlayView.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/22/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kOverlayFadeDuration 0.3

@interface OverlayView : UIView {
}

@property (readonly,nonatomic) IBOutlet UILabel* textLabel;
@property (readonly,nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

+ (id) overlayWithText:(NSString*)title overView:(UIView*)coveredView;
- (void) dismiss;

@end
