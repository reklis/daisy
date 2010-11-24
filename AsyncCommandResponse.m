//
//  AsyncCommandResponse.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import "AsyncCommandResponse.h"


@implementation AsyncCommandResponse

@synthesize responseData;

+ (id) resultFromData:(NSDictionary *)data
{
    AsyncCommandResponse* r = [[[[self class] alloc] init] autorelease];
    [r setResponseData:data];
    return r;
}

@end
