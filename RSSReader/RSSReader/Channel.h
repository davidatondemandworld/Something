//
//  Channel.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject{
    NSString *_title;
    NSString *_url;
    NSDate *_pubDate;
    int _categoryId;
    int _ID;
    NSString *_desc;
}
/*
 频道的标题
 */
@property (nonatomic,copy) NSString *title;
/*
 频道的资源地址
 */
@property (nonatomic,copy) NSString *url;
/*
 频道的发布时间
 */
@property (nonatomic,copy) NSDate *pubDate;
/*
 *
 */
@property (nonatomic,assign) int categoryId;
/*
 *
 */
@property (nonatomic,assign) int ID;
/*
 *
 */
@property (nonatomic,copy) NSString *desc;
/*
 获取频道的文章列表
 */
- (NSArray *) loadItems:(NSError **)error;

@end
