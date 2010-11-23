//
//  XmlHttpRequestCommand.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 11/19/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import "XmlHttpRequestCommand.h"


@implementation XmlHttpRequestCommand

- (NSString*) resourceURL
{
    return [AsyncXmlHttpRequest urlFromBase:[self baseURL] withOptions:self.parameters];
}

- (void) load
{
    if (!self.isLoading) {
        NSString* u = [self resourceURL];
        if (nil != u) {
            _req = [AsyncXmlHttpRequest queueRequest:self.resourceURL
                                          withDelegate:self];
            
            [super didStartLoad];
        }
    }
}

- (void)cancel
{
    [_req cancel];
    
    [super didCancelLoad];
}

- (void)invalidate
{
    if (_req) {
        [self cancel];
    }
    
    [super invalidate];
}

#pragma mark AsyncXmlHttpRequestDelegate

- (void) request:(AsyncXmlHttpRequest*)request completedWithData:(NSDictionary*)data
{
    [self parseResult:data];
    [super didFinishLoad];
}

- (void) request:(AsyncXmlHttpRequest*)request completedWithError:(NSError*) error
{
    [super didFailLoadWithError:error];
}

#pragma mark Child Override Points

- (NSString*) baseURL
{
    return nil;
}

- (NSDictionary*) parameters
{
    return nil;
}

- (void) parseResult:(NSDictionary*) data
{
}

@end
