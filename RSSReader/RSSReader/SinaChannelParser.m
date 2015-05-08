//
//  SinaChannelParser.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SinaChannelParser.h"
#import "Utilities.h"
#import "Channel.h"

@implementation SinaChannelParser

- (NSDictionary *)parseURL:(NSURL *)url error:(NSError **)error{
    NSError *innerError=nil;
    NSData *data=[Utility sendSynchronousRequest:[NSURLRequest requestWithURL:url] error:&innerError];
    
    if (innerError!=nil && error!=NULL) {          
        *error=innerError;
        return nil;
    }    
    
    channelsDict = [[NSMutableDictionary alloc] init];
    
    NSXMLParser *parser=[[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    
    return [channelsDict autorelease];
}

- (void)parseURL:(NSURL *)url completionHandler:(void (^)(NSDictionary *, NSError *))handler{   
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [Utility sendAsynchronousRequest:request completionHandler:^(NSData *data, NSError *error) {
        if (error!=nil) {
            handler(nil,error);
        }
        channelsDict = [[NSMutableDictionary alloc] init];
        
        NSXMLParser *parser=[[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
        handler([channelsDict autorelease],nil);
    }];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser{    
    currentElementName=[[NSMutableString alloc] initWithCapacity:512];   
}

//解析起始标记
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    [currentElementName appendFormat:@"/%@",elementName]; 
    
    //NSLog(@"%@:%@", currentElementName,elementName);
    
    if ([@"/opml/body/outline" isEqualToString:currentElementName]) {//频道类别节点
        NSString *title=[attributeDict objectForKey:@"title"];
        NSRange range=[title rangeOfString:@"-"];
        if (range.location!=NSNotFound) {
            title=[title substringToIndex:range.location];
        }
        channelsArray=[[NSMutableArray alloc] initWithCapacity:32];
        [channelsDict setObject:channelsArray forKey:title];        
    }
    else if([@"/opml/body/outline/outline" isEqualToString:currentElementName]){//频道节点
        Channel *channel=[[Channel alloc] init] ;
        channel.title=[attributeDict objectForKey:@"title"];
        channel.url=[attributeDict objectForKey:@"xmlUrl"];
        [channelsArray addObject:channel];
        [channel release];
    }
}

//解析结束标记
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    int len=[elementName length]+1;
    NSRange range=NSMakeRange([currentElementName length]-len, len);
    
    [currentElementName deleteCharactersInRange:range];
    
    //NSLog(@"%@:%@", currentElementName,elementName);
    
    if([@"outline" isEqualToString:elementName] && [@"/opml/body" isEqualToString:currentElementName] ){
        [channelsArray release];
        channelsArray=nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [currentElementName release];
    currentElementName=nil;
}

@end
