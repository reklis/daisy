//
//  AsyncXmlHttpRequest.h
//  GoalFaceTouch
//
//  Created by Steven Fusco on 8/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AsyncHttpRequest.h"

@protocol AsyncXmlHttpRequestDelegate;

@interface AsyncXmlHttpRequest : AsyncHttpRequest <NSXMLParserDelegate>
{
    @private
    
    BOOL isParsing;
    NSXMLParser* xmlParser;
    NSMutableDictionary* parsedXmlData; // root element
    id currentParserElement;
    id parentElement;
    
    id<AsyncXmlHttpRequestDelegate> delegate;
}

+ (AsyncXmlHttpRequest*) queueRequest:(NSString*)urlString
                           withDelegate:(id<AsyncXmlHttpRequestDelegate>)delegate;

@property (readonly) BOOL isParsing;
@property (readwrite,nonatomic,assign) id<AsyncXmlHttpRequestDelegate> delegate; // weak reference

// Private

- (void) beginXmlParsing;
- (void) completeWithSuccess:(NSDictionary*)dictionary;

@end

#pragma mark -

@protocol AsyncXmlHttpRequestDelegate<NSObject>

@optional

- (void) request:(AsyncXmlHttpRequest*)request completedWithData:(NSDictionary*)data;
- (void) request:(AsyncXmlHttpRequest*)request completedWithError:(NSError*) error;

@end
