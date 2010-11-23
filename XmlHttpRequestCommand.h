//
//  XmlHttpRequestCommand.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/19/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncCommand.h"
#import "AsyncXmlHttpRequest.h"

@interface XmlHttpRequestCommand : AsyncCommand <AsyncXmlHttpRequestDelegate> {
    AsyncXmlHttpRequest* _req;
}

- (NSDictionary*) parameters;
- (NSString*) resourceURL;

#pragma mark Child Override Points

- (NSString*) baseURL;
- (NSDictionary*) parameters;
- (void) parseResult:(NSDictionary*) data;

@end
