//
//  AsyncXmlHttpRequest.m
//  GoalFaceTouch
//
//  Created by Steven Fusco on 8/23/10.
//  Copyright 2010 Cibo Technology, LLC. All rights reserved.
//

#import "AsyncXmlHttpRequest.h"

@implementation AsyncXmlHttpRequest

+ (AsyncXmlHttpRequest*) queueRequest:(NSString*)urlString
                           withDelegate:(id<AsyncXmlHttpRequestDelegate>)delegate
{
    AsyncXmlHttpRequest* req = [[AsyncXmlHttpRequest alloc] initWithURLString:urlString
                                                                         username:nil
                                                                         password:nil
                                                                          timeout:30
                                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad];;
    [req setDelegate:delegate];
    
    NSOperationQueue* q = [AsyncXmlHttpRequest sharedOperationQueue];
    [q addOperation:req];
    
    [req release];
    
    return req;
}

#pragma mark NSXMLParserDelegate

@synthesize isParsing;

@synthesize delegate;

- (BOOL)isExecuting
{
    return ([super isExecuting] || isParsing);
}

- (BOOL)isFinished
{
    return (([super isExecuting] == NO) && (isParsing == NO));
}

- (void) cancel
{
    [xmlParser abortParsing];
    isParsing = NO;
    
    [super cancel];
}

- (void) finishedDownloading
{
    [self beginXmlParsing];
}

- (void) beginXmlParsing
{
    xmlParser = [[NSXMLParser alloc] initWithData:self.downloadedData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    
    isParsing = YES;
    [xmlParser parse];
}

// sent when the parser begins parsing of the document.
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    parsedXmlData = [NSMutableDictionary dictionary];
    currentParserElement = parsedXmlData;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSMutableString* currentCdata = [currentParserElement objectForKey:@"cdata"];
    if (nil == currentCdata) {
        currentCdata = [NSMutableString stringWithString:string];
    } else {
        [currentCdata appendString:string];
    }
    [currentParserElement setObject:currentCdata forKey:@"cdata"];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSMutableDictionary* nextElement = [NSMutableDictionary dictionary];
    [nextElement setObject:attributeDict forKey:@"attributes"];
    
    id existingElement = [currentParserElement objectForKey:elementName];
    if (nil == existingElement) {
        [currentParserElement setObject:nextElement forKey:elementName];
    } else {
        if ([existingElement isKindOfClass:[NSMutableArray class]]) {
            [existingElement addObject:nextElement];
        } else {
            [currentParserElement setObject:[NSMutableArray arrayWithObjects:existingElement, nextElement, nil] forKey:elementName];
        }
    }
    parentElement = currentParserElement;
    currentParserElement = nextElement;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    currentParserElement = parentElement;
}

// reports a fatal error to the delegate. The parser will stop parsing.
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self completeWithError:parseError];
}

// If validation is on, this will report a fatal validation error to the delegate. The parser will stop parsing.
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    [self completeWithError:validationError];
}

// sent when the parser has completed parsing. If this is encountered, the parse was successful.
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self completeWithSuccess:parsedXmlData];
}


#pragma mark AsyncXmlHttpRequestDelegate

- (void) completeWithSuccess:(NSDictionary*)dictionary
{
    isParsing = NO;
    
    if ([delegate respondsToSelector:@selector(request:completedWithData:)]){
        [delegate request:self completedWithData:dictionary];
    }
}

- (void) completeWithError:(NSError*)error
{
    [super completeWithError:error];
    
    isParsing = NO;
    
    if ([delegate respondsToSelector:@selector(request:completedWithError:)]){
        [delegate request:self completedWithError:error];
    }
}

@end



