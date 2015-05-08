//
//  RSSFormatAnalyzer.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RSSFormatAnalyzer.h"

@implementation RSSFormatAnalyzer

- (RSSFormat)analyze:(NSData *)data{
    _format=kUnknown;
    
    NSXMLParser *xmlParser=[[[NSXMLParser alloc] initWithData:data] autorelease];
    [xmlParser setDelegate:self];
    [xmlParser parse]; 
    return _format;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([@"rss" isEqualToString:elementName]) {
        _format=kRSS;
    }
    else if([@"feed" isEqualToString:elementName]){
        _format=kFeed;
    }
    [parser abortParsing];
}

@end
