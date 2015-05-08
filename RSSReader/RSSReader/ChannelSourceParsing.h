//
//  ChannelSourceParsing.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChannelSourceParsing 
/*
 根据频道资源URL，解析并获取RSS频道列表
 */
- (NSDictionary *) parseURL:(NSURL *) url error:(NSError **) error;
/*
 根据频道资源URL，异步解析并获取RSS频道列表
 */
- (void) parseURL:(NSURL *) url completionHandler:(void (^)(NSDictionary*dict, NSError*error)) handler;

@end
