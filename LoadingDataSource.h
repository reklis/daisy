//
//  LoadingDataSource.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoadingDataSource : NSObject <UITableViewDataSource,UITableViewDelegate> {

}

+ (id) loadingDataSource;

@end
