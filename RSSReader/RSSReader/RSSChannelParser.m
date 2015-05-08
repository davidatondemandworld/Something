//
//  RSSChannelParser.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RSSChannelParser.h"
#import "Article.h"
#import "Utilities.h"

@implementation RSSChannelParser

- (NSDictionary *)parseData:(NSData *)data error:(NSError **)error{
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release]; 
    
    NSDate *date=[NSDate dateWithString:_pubDate format:@"EEE, dd MMM yyyy HH:mm:ss zzz"];    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:date,kPubDate,_articles,kArticles, nil];
    return dict;
}

#pragma mark - NSXMLParserDelegateº

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    _articles = [[NSMutableArray alloc] init];
    currentElementName=[[NSMutableString alloc] initWithCapacity:512];   
}

//解析起始标记
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{    
    [currentElementName appendFormat:@"/%@",elementName]; 
    
    NSLog(@"%@:%@", currentElementName,elementName);    
    
    if([@"/rss/channel/item" isEqualToString:currentElementName]){//item节点表示文章节点
        _article = [[Article alloc] init];
    }    
}
//解析CDATA数据节点
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{ 
    if ([@"/rss/channel/pubDate" isEqualToString:currentElementName]) {
        _pubDate=[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    }     
    else if([@"/rss/channel/item/title" isEqualToString:currentElementName]){            
        _article.title = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];            
    }
    else if([@"/rss/channel/item/link" isEqualToString:currentElementName]){            
        _article.url = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];            
    }
    else if([@"/rss/channel/item/author" isEqualToString:currentElementName]){            
        _article.author = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];            
    }
    else if([@"/rss/channel/item/pubDate" isEqualToString:currentElementName]){        
        _article.pubDate=[NSDate dateWithString:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding] format:@"EEE, dd MMM yyyy HH:mm:ss zzz"];              
    }
    else if([@"/rss/channel/item/description" isEqualToString:currentElementName]){            
        _article.descriptionText = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];            
    }
}
//解析文本节点
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{ 
    if ([@"/rss/channel/pubDate" isEqualToString:currentElementName]) {
        _pubDate=[string copy];
    }
//    else if([@"/rss/channel/item/title" isEqualToString:currentElementName]){            
//        _article.title = string;            
//    }
    else if([@"/rss/channel/item/link" isEqualToString:currentElementName]){            
        _article.url = string;            
    }
    else if([@"/rss/channel/item/author" isEqualToString:currentElementName]){            
        _article.author = string;            
    }
    else if([@"/rss/channel/item/pubDate" isEqualToString:currentElementName]){     
        _article.pubDate=[NSDate dateWithString:string format:@"EEE, dd MMM yyyy HH:mm:ss zzz"];                        
    }
//    else if([@"/rss/channel/item/description" isEqualToString:currentElementName]){            
//        _article.descriptionText = string;            
//    }
}
//解析结束标记
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    [currentElementName 
     replaceOccurrencesOfString:[NSString stringWithFormat:@"/%@",elementName]
     withString:@"" 
     options:NSBackwardsSearch 
     range:NSMakeRange(0, [currentElementName length])];
    
    NSLog(@"%@:%@", currentElementName,elementName);
    
    if([@"item" isEqualToString:elementName] && [@"/rss/channel" isEqualToString:currentElementName]){
        [_articles addObject:_article];
        [_article release];
        _article=nil;
    }
}

@end
