//
//  ChannelParsing.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPubDate @"pubDate"
#define kArticles @"articles"

@protocol ChannelParsing
/*
 解析并获取RSS文章列表
 data表示频道对应的xml数据
 return NSDictionary 包含kPubDate(频道发布日期),kArticles(文章列表)
 */
- (NSDictionary *) parseData:(NSData *) data error:(NSError **) error;
@end
