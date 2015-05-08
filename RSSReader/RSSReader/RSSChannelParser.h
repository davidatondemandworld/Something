//
//  RSSChannelParser.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelParsing.h"

@class Article;

@interface RSSChannelParser : NSObject<ChannelParsing,NSXMLParserDelegate>{
    NSString *_pubDate;//频道发布时间
    NSMutableArray *_articles;//存放频道的文章列表
    Article *_article;//用于解析XML数据时，临时存放文章对象
    NSMutableString *currentElementName;//用于解析XML数据时，临时存放当前正在解析的元素名称
}

@end
